# 2020-Capstone
## 주제

Custom YOLO V3 Object Detection을 이용한 페트병 라벨 자동 분리기기<br><br>
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
