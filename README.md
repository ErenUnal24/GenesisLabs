Bu uygulamada bir genetik laboratuvarının iş akışını mobil uygulamaya entegre ettim. 6 farklı çalışan tipi için kullanıcı girişi var. Her biri kendi bilgileriyle giriş yaptığında kendilerine atanan görevle ilgili farklı ekranlara yönlendiriliyorlar.

1. Admin Kullanıcısı:
   Tüm ekranlara erişebiliyor ve diğer kullanıcılardan farklı olarak sisteme yeni bir kullanıcı ekleyebilir. (Örneğin Eren adlı kullanıcıyı biyolog tipinden kendi mail adresi ve varsayılan bir şifre ile ekler. Eren bu bilgiler ile giriş yapıp şifresini güncelleyebilir)

2. Danışma Kullanıcısı:
   Laboratuvara bir hasta geldiğinde onun bilgilerini sisteme girer ve yeni bir hasta oluşur. Daha sonra hasta kimlik numarası ile yeni bir test oluşturur. (Örneğin Ayşe hastası için bir CFTR Gen analizi testi oluşmuş oldu). Test statüsü "Numune Bekliyor" durumundadır ve artık Numune Kabul ekranında görüntülenebilir.

3. Numune Kabul Kullanıcısı:
   Hastamız Numune Kabul birimine gider. Burada, laorantların çalışması için hastadan numune alınır. Numune alındıktan sonra test statüsü "Test Bekliyor" olarak güncellenir ve Labaront ekranına düşer.

4. Laborant Kullanıcısı:
   Alınan numune laboranta teslim edilir. Numune çalışıldıktan sonra elde edilen sonuçlar ile test güncellenir. Sonuçlar girilip kaydedilince test statüsü "Analiz Bekliyor" olarak güncellenir ve testimiz Biyolog kullanıcılarının ekranına düşer.

5. Biyolog Kullanıcısı:
   Biyolog sonuçları inceler ve bir analiz girer. Analiz girilince test statüsü "Analiz Bekliyor" olarak güncellenir ve yine biyologların ekranında bulunan "Rapor Bekliyor" içinde görüntülenebilir. Rapor girişi de yapıldıktan sonra test statüsü "Onay Bekliyor" olarak güncellenir ve Uzman kullanıcısının ekranına düşer.

6. Uzman Kullanıcısı:
   Uzman, biyolog tarafından girilen analiz ve rapor sonuçlarını inceler ve laboratuvar sonuçlarıyla karşılaştırır. Eğer onay verirse kendi kararına göre "Genetik Danışmanlık Tavsiye Ediliyor" toggle'ını işaretler. Sonrasında PDF formatında bir rapor oluşur. Eğer onay vermezse testin statüsü "Uzman Tarafından Reddedildi" olarak güncellenir ve testimiz biyologların ekranında bulunan "Revize Edilecek" menüsüne düşer ve işlemler tekrarlanır.

Rapor oluştuktan sonra hastalar uygulamanın giriş ekranında bulunan "Hasta Girişi" butonuna tıklayıp kendi kimlik numaralarıyla raporlarını sorgulayabilir.


In this application, I integrated the workflow of a genetic laboratory into a mobile app. There are six different types of employee logins. When each user logs in with their credentials, they are directed to different screens based on their assigned tasks.

Admin User: This user has access to all screens and can add new users to the system, unlike other users. (For example, the admin can add a user named Eren as a biologist with their email address and a default password. Eren can log in with these details and update the password.)

Reception User: This user enters patient information into the system when a patient arrives at the laboratory, creating a new patient profile. They can also create a new test using the patient’s ID number. (For example, a CFTR Gene analysis test might be created for a patient named Ayşe). The test status is set to "Awaiting Sample" and can now be viewed on the Sample Acceptance screen.

Sample Acceptance User: This user handles the process when the patient goes to the Sample Acceptance unit. They collect the sample from the patient for lab work. Once the sample is taken, the test status is updated to "Awaiting Test" and is visible on the Laboratory screen.

Laboratory User: This user receives the sample and performs the necessary tests. After completing the test, they update the test with the results. Once the results are entered and saved, the test status is updated to "Awaiting Analysis" and appears on the Biologist users’ screens.

Biologist User: This user reviews the results and enters an analysis. Once the analysis is entered, the test status is updated to "Awaiting Report" and is visible under the "Pending Reports" section on the biologists' screens. After the report is completed, the test status is updated to "Awaiting Approval" and moves to the Specialist user's screen.

Specialist User: This user reviews the analysis and report results entered by the biologist and compares them with the laboratory findings. If the specialist approves, they can check the "Genetic Counseling Recommended" toggle. A PDF report is then generated. If the specialist does not approve, the test status is updated to "Rejected by Specialist" and moves to the "To Be Revised" section on the biologists' screens, where the process starts again.

After the report is created, patients can click the "Patient Login" button on the app's main screen and use their ID numbers to view their reports.


![Screenshot 2024-06-20 at 02 11 47](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/81c0cec7-e8ab-4760-a766-700e1f1eb3eb)
![Screenshot 2024-06-20 at 02 11 58](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/d717898b-da25-4a34-b2da-de3ef6ffa36c)
![Screenshot 2024-06-20 at 02 12 09](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/f3c336a4-5771-4361-987c-8af5b9196b85)
![Screenshot 2024-06-20 at 02 13 00](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/6ee22f2b-62a8-4970-b03c-c628198f33c5)
![Screenshot 2024-06-20 at 02 13 20](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/8b60fae1-6969-4c10-b3ed-3899966607ff)
![Screenshot 2024-06-20 at 02 14 14](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/1e2e8bd1-c118-4073-992d-ae89a61fdc32)
![Screenshot 2024-06-20 at 02 16 49](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/3645eaf3-7553-4076-900d-4bf28e887cf6)
![Screenshot 2024-06-20 at 02 17 07](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/6c5dc88e-81f1-40dc-90cd-22ef56d2201e)
![9](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/59d84731-e6ab-4b1f-9732-df4cc2f68967)
![10](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/a8e6ec97-bdea-47d9-b959-97cba13c86d2)
![Screenshot 2024-06-20 at 02 23 52](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/a88c40e4-741b-4861-aa76-1bf88f946191)
![12](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/6809ee2e-8d71-46ce-89f9-0fb023dec797)
![13](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/5395555f-dedf-4bfc-a016-27467864b139)
![Screenshot 2024-06-20 at 02 25 27](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/44fcfcff-9f6d-4472-a28a-17d706cbd714)
![15](https://github.com/ErenUnal24/GenesisLabs/assets/92259243/1ae655fa-3089-422b-a9c2-14b262ef576a)
