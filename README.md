# 2020-Capstone
## 주제

Custom YOLO V3 Object Detection을 이용한 페트병 라벨 자동 분리기기<br><br>
<img src = "https://github.com/NEULiee/2020-Capstone/blob/main/photo/img_fullshot.jpeg" width="500" height="300">
<br>
## 유튜브 링크 (사진클릭)

[![welle](https://img.youtube.com/vi/_Ru-F-8oGIk/0.jpg)](https://www.youtube.com/watch?app=desktop&v=_Ru-F-8oGIk&feature=youtu.be "시연 영상")<br><br>
## 동기

올바른 페트병 분리 배출 방법은 병뚜껑과 라벨을 제거하는 것이다. 이 중에서 라벨제거의 자동화를 통한 편의성 향상을위해 기기를 제작하였다.<br><br>
## 기술 스택

- 크롤링 (BeautifulSoup)
- 딥러닝 (Yolo V3, colab, pythorch)
- 임베디드 (아두이노, 라즈베리파이 4)
- 어플리케이션 (iOS)
- 서버 (Firebase)
<br>


## 기기의 workflow





<img src = "https://github.com/NEULiee/2020-Capstone/blob/main/photo/workflow.png" width="600" height="300">


1. 유저가 ios 어플리케이션에서 페트병을 인식합니다.
2. 페트병에 라벨이 없다면 바로 분리수거 함으로 배출합니다.
3. 페트병에 라벨이 있다면 기기 위에 페트병을 놓아 라즈베리 카메라로 라벨의 위치를 detect 합니다. (yolo v3 사용)
4. 페트병의 라벨의 위치가 절단기의 위치와 다르다면 모터를 돌려서 절단기의 위치로 옮깁니다.
5. 라벨과 절단기의 위치가 같아지면 절단기로 라벨을 제거합니다.
6. 라벨을 제거후 분리수거 함으로 배출합니다.
<br>

## 코드
> 라즈베리 파이에서 main.py를 작동시킨 후 application을 작동해야 합니다.
> 위치 조정 및 테스트는 CAMERA_TEST.py에서 진행하였습니다.
### Colab 학습 코드
train_data.py


### 딥러닝
yolov3_custom2_last.weights - 딥러닝 모델 <br>
yolov3_custom2.cfg - configure file <br>
coco.names - names file <br>


### 라즈베리파이 내  코드
main.py -  전체 control tower, server 그리고 arduino와 연동
CAMERA_TEST.py - real time detect 테스트,  좌표값 위치 맞추기 테스트


### 아두이노 내 코드
do_motor.ino - Serial 1 , left right motor 담당
cut_motor.ino - Serial 2, cut motor 담당


### iOS Application 코드
LiveCapturingApp.zip
