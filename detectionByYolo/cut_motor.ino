#include <Servo.h>
Servo myservo;

//cut motor

int pos = 0;    // initial angle
int relay = 4;  // port number
int servo = 9;  // port number

void setup() {
  Serial.begin(9600);
  pinMode(relay, OUTPUT);
  digitalWrite(relay, LOW);
  myservo.attach(9);
}

void loop() {
  if(Serial.available()) {
    char b = Serial.read();

    if(b == 'a') {
      for (pos = 90; pos >= 30; pos -=1) {
        myservo.write(pos);
        delay(15);
      }
      digitalWrite(relay, HIGH);
      delay(17000);
      digitalWrite(relay, LOW);
      for (pos = 30; pos <= 90; pos +=1) {
        myservo.write(pos);
        delay(15);
      }
    }
}

}
