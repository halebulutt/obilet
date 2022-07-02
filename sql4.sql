
 -- Yolcu Ekleyen Prosedür-- 

 CREATE PROCEDURE stp_yolcuEkleme
( 
   
   @yolcuAd NVARCHAR(50),
   @yolcuSoyad NVARCHAR(50),
   @yolcuCinsiyet NVARCHAR(10),
   @yolcuDogumTarihi DATE,
   @yolcuTelefonNo VARCHAR(50) 
)
AS
BEGIN
SET NOCOUNT ON
INSERT INTO yolcu
(
    
	ad,
	soyad,
	cinsiyet,
	dogumTarihi,
	telefonNO

)
VALUES
(
	@yolcuAd,
	@yolcuSoyad,
	@yolcuCinsiyet,
	@yolcuDogumTarihi,
	@yolcuTelefonNo
)
END

exec stp_yolcuEkleme 'Mehmet Can' , 'Yaþ' , 'Erkek' , '2001-02-04' , '5525882967'

select * from yolcu



-- Join ve View --
CREATE VIEW vwBilgilendirme 
AS
select yolcu.ad , yolcu.soyad , yolcu.cinsiyet , bilet.tarih , bilet.saat , bilet.fiyat , bilet.kalkisOtogari , 
otogar.otogarAd , bilet.otobusKoltukID , otobusKoltuk.koltukID, koltuk.koltukNo FROM yolcu join bilet on yolcu.yolcuID = bilet.yolcuID join
otogar on bilet.kalkisOtogari = otogar.otogarID JOIN otobusKoltuk on bilet.otobusKoltukID = otobusKoltuk.otobusKoltukID 
join koltuk on otobusKoltuk.otobusKoltukID = koltuk.koltukNo 
Go

select * from vwBilgilendirme




-- Skaler deðer döndüren fonksiyon--

create function fon_firmaIdyeGoreFirmaAdi(@firma_id INT)
RETURNS NVARCHAR(50)
AS
BEGIN
DECLARE @firmaAd NVARCHAR(50)
		SET @firmaAd=(SELECT firmaAd From firma where firmaID=@firma_id)
		Return @firmaAd
END

select dbo.fon_firmaIdyeGoreFirmaAdi(5)

-- Bilet id ye göre fiyat döndüren skaler fonksiyon-- 

create function fon_biletIdyeGoreBiletFiyati(@bilet_id INT)
RETURNS MONEY
AS
BEGIN
DECLARE @fiyat MONEY
		SET @fiyat=(SELECT fiyat From bilet where biletID=@bilet_id)
		Return @fiyat
END

select dbo.fon_biletIdyeGoreBiletFiyati(7)




-- Tablo döndüren fonksiyon--

CREATE FUNCTION [dbo].[fnt_yolcular2]
(
   @yolcuID INT 
)
RETURNS TABLE
AS RETURN 
(
select (bilet.yolcuID) As YolcuID,
yolcu.ad as yolcuad,
bilet.tarih as tarih,
bilet.fiyat as fiyat,
bilet.saat as saat,
odeme.odemeTur as odemeTur


from bilet join yolcu on yolcu.yolcuID=bilet.yolcuID
join odeme on odeme.odemeID = bilet.odemeID

Where yolcu.yolcuID = @yolcuID
)

select * from fnt_yolcular2(4)


-- Trigger --

CREATE TRIGGER tr_TabloSilinmesin ON database
FOR DROP_TABLE
AS
 Print 'Veritabanindan tablo silinemez'
 ROLLBACK

 drop table bilet
