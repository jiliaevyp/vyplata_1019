class UserMailer < ApplicationMailer
  default from: 'sendertab@catelecom.ru'

  def welcome_email(tabel)
    @tabel = tabel
    @mond = Mond.find_by(id: @tabel.mond_id)
    #abort @tabel.title.inspect
    subject_mail = 'карта начисления ' + @tabel.title + ' за ' + $monat_array[@mond.num_monat]
    mail(to: @tabel.email, subject: subject_mail)
  end

end
