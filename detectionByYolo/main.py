import cv2
import numpy as np
import time
import pyrebase
import serial

#main control
# 사용자 위치와 관찰자 위치가 반대여서
# 관찰자 위치의 코드 입니다. 관찰자가 왼쪽으로 돌리면 사용자 입장에서는 오른쪽으로 가게 됩니다.

#Firebase Configuration
config = {
  "apiKey": "AIzaSyAoU6E79R_z863K147ppOhjS5OWOEtFYVY",
  "authDomain": "wellre-1ba7d.firebaseapp.com",
  "databaseURL": "https://wellre-1ba7d.firebaseio.com",
  "storageBucket": "wellre-1ba7d.appspot.com"
}

firebase = pyrebase.initialize_app(config)

#Firebase Database Intialization
db = firebase.database()

#left right 정도 맞추기


#commute Arduino with Serial
ser = serial.Serial('/dev/ttyACM0',9600)
ser2 =serial.Serial('/dev/ttyACM1',9600)

def motor_left() :
     #왼쪽으로 가서 검증
     c ='l'
     c = c.encode('utf-8')
     ser.write(c)
     
def motor_right() :
     #오른쪽으로 굴린다.
     c ='r'
     c = c.encode('utf-8')
     ser.write(c)
     
def motor_finish():
    #success
    c = 'f'
    c = c.encode('utf-8')
    ser.write(c)
     
def motor_down():
    num ='a'
    num = num.encode('utf-8')
    ser2.write(num)
     

def detect() :

    # Load Model
    net = cv2.dnn.readNet("/home/pi/Desktop/yolov3_custom2_last.weights", "/home/pi/Desktop/yolov3_custom2.cfg")
    classes = []
    with open("/home/pi/Desktop/coco.names", "r") as f:
        classes = [line.strip() for line in f.readlines()]
    layer_names = net.getLayerNames()
    output_layers = [layer_names[i[0] - 1] for i in net.getUnconnectedOutLayers()]
    colors = np.random.uniform(0, 255, size=(len(classes), 3))

    # Camera start
    cap = cv2.VideoCapture(0)
    time.sleep(1)


    font = cv2.FONT_HERSHEY_PLAIN
    starting_time = time.time()
    frame_id = 0


    for i in range(1):   
        _, frame = cap.read();
        frame_id += 1
       
        height, width, channels = frame.shape

        # Detecting start
        blob = cv2.dnn.blobFromImage(frame, 0.00392, (416, 416), (0, 0, 0), True, crop=False)

        net.setInput(blob)
        outs = net.forward(output_layers)
        
        
        #보여주는 화면에
        class_ids = []
        confidences = []
        boxes = []
        for out in outs:
            for detection in out:
                scores = detection[5:]
                class_id = np.argmax(scores)
                confidence = scores[class_id]
                if confidence > 0.4:
                    # detected
                    center_x = int(detection[0] * width)
                    center_y = int(detection[1] * height)
                    w = int(detection[2] * width)
                    h = int(detection[3] * height)

                    # Rectangle
                    x = int(center_x - w / 2)
                    y = int(center_y - h / 2)

                    boxes.append([x, y, w, h])
                    confidences.append(float(confidence))
                    class_ids.append(class_id)
        
        indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.4)
        

       
        for i in range(len(boxes)):
            if i in indexes:
                x, y, w, h = boxes[i]
                label = str(classes[class_ids[i]])
                confidence = confidences[i]
                color = colors[class_ids[i]]
                cv2.rectangle(frame, (x, y), (x + w, y + h), color, 2)
                cv2.putText(frame, label + " " + str(round(confidence,2)), (x, y + 30), font, 3, color, 3)
       
        #none 다시 돌아왔을 때 디텍트를 위한 코드
        if len(indexes) ==0 :
            #벗겨져서 아무것도 안 보임
            #motor_finish()
            return 4  
        if len(indexes) ==1 and label == 'pet':
            #motor_finish()
            return 9

        correct_pos= abs(width/2 - x)
        print(correct_pos)
        #correct
        if len(indexes) ==2 and correct_pos < 300:
            print("pet label 다 잡히고 correct 위치임 다음으로 motor 내려감")
            time.sleep(4)
            motor_down()
            time.sleep(22)
            motor_right()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            return 5
        if len(indexes) ==1 and correct_pos<300:
            print("pet만 잡히고 correct 위치임 다음으로 motor 내려감")
            time.sleep(4)
            motor_down()
            time.sleep(22)
            motor_right()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            motor_left()
            time.sleep(1)
            return 6
        
        #Incorrect
        if len(indexes) ==1 and correct_pos >=300:
            print("pet or label만 잡히고 잘못된 위치임 다음은 한칸 왼쪽으로")
            motor_left()
            time.sleep(1)
            return 7
        if len(indexes) ==2 and correct_pos >= 300:
            print("pet label 다 잡히고 잘못된 위치임 다음은 한칸 왼쪽으로")
            motor_left()
            time.sleep(1)
            return 8
        
         
    
        
        elapsed_time = time.time()- starting_time
        fps = frame_id / elapsed_time
        cv2.putText(frame,"FPS: " + str(round(fps,2)),(10,50),font,4,(0,0,0),3)
                    
        cv2.imshow("Image", frame)
                    
        key = cv2.waitKey(1)
        if key ==27:
            break

    cap.release()

while True :
    hasLabel = db.child("pet").get()
    for user in hasLabel.each():        
        #pet일때 그냥 left로 보내고 수거 끝!
         if(user.val() =="none"):
            time.sleep(3)
            motor_finish()
            time.sleep(3)
            db.update({
              u'end': "finish"})
            exit(1)

         if(user.val() =="label"):
            time.sleep(3)
            #start
            x = detect()

            #카메라에 안 보임
            if x ==4:
                #왼쪽으로 한 번 간 다음에 다시 detect
                print("라벨이고 카메라에 안보여서 다음에 모터 왼쪽으로 돌릴거임")
                time.sleep(1)
                motor_left()
                time.sleep(1)
                c = detect()

                #Right position and cut 한거임
                if c== 5 or c ==6:
                   print("다시 봐서 제대로 있길래 짤름 짤렸나 볼거임")
                   a = detect()
                   time.sleep(10)
                   # success
                   if a ==4 or a == 9:
                       print("잘 짤린거임")
                       time.sleep(4)
                       motor_finish()
                       #수거완료 send a signal to server
                       time.sleep(3)
                       db.update({
                         u'end': "finish"})
                       exit(1)
                   elif a ==5 or a ==6:
                        time.sleep(8)
                        last = detect()
                        time.sleep(1)
                        
                        if last == 4 or last ==9:
                            print("두번 해봄 짤렸음 ")
                            #두번해서 성공 끝
                            motor_finish()
                            db.update({
                               u'end': "finish"})
                            exit(1)
                        else:
                            print("twice but failure")
                            db.update({
                              u'end': "finish"})
                            exit(1)
                   else :
                        print(" 잘못된 위치로 온 경우는 그냥 실패로 볼 것")
                        print("Fail")
                        db.update({
                           u'end': "finish"})
                        exit(1)
                    
                #잘못된 위치로 온다고 가정은 하지 ㄴㄴ
                else:
                    print("왼쪽으로 굴려서 잘못된 위치로 온 경우는 없기로 하고 그냥 종료")
                    print("Bye")
                    exit(1)

            #correct
            elif x ==5 or x ==6:
                print("올바른 위치로와서 짤른거임")
                b = detect()
                time.sleep(10)
                if b == 4 or b ==9 :
                    print("올바른 위치에서 한 번에 잘 짤림 성공")
                    motor_finish()
                    #성공
                    db.update({
                      u'end': "finish"})
                    exit(1)
                
                #올바른 위치일때로만 가정
                else :
                    motor_down()
                    time.sleep(22)
                    motor_right()
                    time.sleep(1)
                    motor_left()
                    time.sleep(1)
                    motor_left()
                    time.sleep(5)
                    d =detect()
                    time.sleep(1)
                    if d == 4 or d ==9:
                        print("올바른 위치에 처음온거 근데 안짤려서 두번 짤랐는데 잘 짤림")
                        #성공
                        motor_finish()
                        db.update({
                          u'end': "finish"})
                        exit(1)
                    else:
                        print("Twice but Failure")
                        db.update({
                          u'end': "finish"})
                        exit(1)

            elif x ==7 or x ==8:
                print("잘못된 위치라서 왼쪽으로 한 번 보냄")
                time.sleep(5)
                f = detect()
                
                if f == 5 or f==6:
                    print("왼쪽으로 보내고 짤라본 결과임")
                    g = detect()
                    time.sleep(5)
                    print("또 짤름")
                    if g == 4 or g ==9 :
                        time.sleep(5)
                        print("잘못된 위치 왼쪽으로 보내서 또 짤랐는데 이번엔 잘 됨")
                        motor_finish()
                        #성공
                        db.update({
                          u'end': "finish"})
                        exit(1)
                    #5 6 이라고만 가정
                    else :
                        print("왼쪽으로 보내면 다 올바른 위치라고 가정하고 근데 이건 잘 안짤려서 다시 짜르는거임")
                        motor_down()
                        time.sleep(22)
                        motor_right()
                        time.sleep(1)
                        motor_left()
                        time.sleep(1)
                        motor_left()
                        time.sleep(1)
                        d =detect()
                        if d == 4 or d ==9:
                            print("잘못된 위치 두번째해서 성공")
                            #성공
                            motor_finish()
                            db.update({
                              u'end': "finish"})
                            exit(1)
                        else:
                            print("Twice but Failure")
                            db.update({
                              u'end': "finish"})
                            exit(1)
                        
                else:
                    print("실패 ")
                    exit(1)
                    
            else:
                print("BYE BYE")


