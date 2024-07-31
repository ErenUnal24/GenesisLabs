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
