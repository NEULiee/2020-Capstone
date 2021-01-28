int Index;


//left right motor


void setup()

{



  pinMode(6, OUTPUT); //Enable

  pinMode(3, OUTPUT); //Step

  pinMode(2, OUTPUT); //Direction

  Serial.begin(9600);

  digitalWrite(6, LOW);

}





//500 4

//1000 8



void loop()

{



  while (Serial.available() > 0) {



    char c = Serial.read();

    //Serial.println(c);

    if ( c == 'l') {
      Serial.println(c);
   
      //left

      digitalWrite(2, HIGH);

      for (Index = 0; Index < 500; Index++)

      {

        digitalWrite(3, HIGH);

        delayMicroseconds(1000);

        digitalWrite(3, LOW);

        delayMicroseconds(1000);



      }



    }

    else if ( c == 'r') {



      //right once

      digitalWrite(2, LOW);
       for (Index = 0; Index < 4000; Index++)

      {

        digitalWrite(3, HIGH);

        delayMicroseconds(1000);

        digitalWrite(3, LOW);

        delayMicroseconds(1000);

      }






      for (Index = 0; Index <20000; Index++)

      {

        digitalWrite(3, HIGH);

        delayMicroseconds(200);

        digitalWrite(3, LOW);

        delayMicroseconds(200);

      }





    }


    else if ( c == 'f') {



      //right once

      Serial.println(c);
      Serial.println("tttttqqq");

      //left

      digitalWrite(2, HIGH);

      for (Index = 0; Index < 4000; Index++)

      {

        digitalWrite(3, HIGH);

        delayMicroseconds(500);

        digitalWrite(3, LOW);

        delayMicroseconds(500);



      }




    }
  }



  // while(1);

}
