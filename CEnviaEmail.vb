Public Class CEnviaEmail

    Public strContaEmail As String
    Public strSMTP As String
    Public strContaSenha As String
    Public strContaRemetente As String

    Public Function fEnviaEmail(ByVal strDestinatario As String, ByVal strAssunto As String, ByVal strCorpoMSG As String, ByVal strAnexoCaminho As String, ByVal strResponderPara As String) As String

        Dim arrDestinatarios() As String
        Dim intQtd As Integer

        'cria uma instância do objeto MailMessage
        Dim mMailMessage As New Net.Mail.MailMessage()

        'define o formato do email HTML
        'mMailMessage.IsBodyHtml = True

        'define o endereço do remetente
        mMailMessage.From = New Net.Mail.MailAddress(strContaRemetente)

        'define o endereço de resposta
        mMailMessage.ReplyTo = New Net.Mail.MailAddress(strResponderPara)

        'define o assunto 
        mMailMessage.Subject = strAssunto

        'If Not String.IsNullOrEmpty(strConfirmacaoDeLeitura) Then
        '    'para incluir a msg de email recebido
        '    mMailMessage.Headers.Add("Disposition-Notification-To", strConfirmacaoDeLeitura)
        'End If


        'define o corpo da mensagem
        mMailMessage.Body = strCorpoMSG

        'anexar arquivo
        If Trim(strAnexoCaminho) <> "" Then
            mMailMessage.Attachments.Add(New Net.Mail.Attachment(strAnexoCaminho))
        End If

        Try
            'Cria uma instância de SmtpClient 
            Dim smtp As New Net.Mail.SmtpClient(strSMTP)

            With smtp

                .Credentials = New Net.NetworkCredential(strContaEmail, strContaSenha)
                .Port = 25
                '.EnableSsl = False
                .Timeout = 200000
                '.UseDefaultCredentials = True

            End With

            'pra oxiteno retirei o Enable e o UseDefault
            '.EnableSsl = False
            '.UseDefaultCredentials = True
            'alterei também pra enviar direto ao email do destinatario, sem ser oculto

            'mMailMessage.Bcc.Add((strDestinatario.Replace(";", ",")))


            'Estava enviando apenas o primeiro, coloquei pra enviar de um em um
            'mMailMessage.To.Add(New Net.Mail.MailAddress((strDestinatario.Replace(";", ","))))
            'smtp.Send(mMailMessage)
            'Dim StrTemp As String
            'StrTemp = ""
            'smtp.Send(mMailMessage)

            ''        'smtp.SendAsync(mMailMessage, StrTemp)
            'Threading.Thread.Sleep(20000)


            ''Verifica qtd de emails para envio
            arrDestinatarios = Split(Replace(strDestinatario, ",", ";"), ";") 'Tranforma o conteudo em Vetor usando o separador ;
            intQtd = UBound(arrDestinatarios) 'indexa o vetor
            For intI As Integer = 0 To intQtd
                If Len(arrDestinatarios(intI)) > 5 And arrDestinatarios(intI) Like "*@*" Then
                    mMailMessage.To.Clear()
                    'define o destinario da mensagem
                    mMailMessage.To.Add(New Net.Mail.MailAddress(arrDestinatarios(intI)))
                    ' Envia o email
                    ' smtp.Timeout = 1800

                    smtp.Send(mMailMessage)

                    For intTemp As Integer = 0 To 1000

                    Next

                End If
            Next
            mMailMessage.Dispose()
            Return "Mail sent successfully!"

        Catch ex As Exception
            Return "Error: " & ex.Message.ToString
        End Try

    End Function

    Public Function fEnviaEmail(ByVal strDestinatario As String, ByVal strAssunto As String, ByVal strCorpoMSG As String, ByVal strAnexoCaminho As String, ByVal strResponderPara As String, ByVal strCopiaDestinatario As String) As String

        Dim arrDestinatarios() As String
        Dim intQtd As Integer

        'cria uma instância do objeto MailMessage
        Dim mMailMessage As New Net.Mail.MailMessage()

        'define o formato do email HTML
        'mMailMessage.IsBodyHtml = True

        'define o endereço do remetente
        mMailMessage.From = New Net.Mail.MailAddress(strContaRemetente)

        'define o endereço de resposta
        mMailMessage.ReplyTo = New Net.Mail.MailAddress(strResponderPara)

        'define o assunto 
        mMailMessage.Subject = strAssunto

        Dim cc = New Net.Mail.MailAddress(strCopiaDestinatario)
        mMailMessage.CC.Add(cc)
        'If Not String.IsNullOrEmpty(strConfirmacaoDeLeitura) Then
        '    'para incluir a msg de email recebido
        '    mMailMessage.Headers.Add("Disposition-Notification-To", strConfirmacaoDeLeitura)
        'End If


        'define o corpo da mensagem
        mMailMessage.Body = strCorpoMSG

        'anexar arquivo
        If Trim(strAnexoCaminho) <> "" Then
            mMailMessage.Attachments.Add(New Net.Mail.Attachment(strAnexoCaminho))
        End If

        Try
            'Cria uma instância de SmtpClient 
            Dim smtp As New Net.Mail.SmtpClient(strSMTP)

            With smtp

                .Credentials = New Net.NetworkCredential(strContaEmail, strContaSenha)
                .Port = 25
                '.EnableSsl = False
                .Timeout = 200000
                '.UseDefaultCredentials = True

            End With

            'pra oxiteno retirei o Enable e o UseDefault
            '.EnableSsl = False
            '.UseDefaultCredentials = True
            'alterei também pra enviar direto ao email do destinatario, sem ser oculto

            'mMailMessage.Bcc.Add((strDestinatario.Replace(";", ",")))


            'Estava enviando apenas o primeiro, coloquei pra enviar de um em um
            'mMailMessage.To.Add(New Net.Mail.MailAddress((strDestinatario.Replace(";", ","))))
            'smtp.Send(mMailMessage)
            'Dim StrTemp As String
            'StrTemp = ""
            'smtp.Send(mMailMessage)

            ''        'smtp.SendAsync(mMailMessage, StrTemp)
            'Threading.Thread.Sleep(20000)


            ''Verifica qtd de emails para envio
            arrDestinatarios = Split(Replace(strDestinatario, ",", ";"), ";") 'Tranforma o conteudo em Vetor usando o separador ;
            intQtd = UBound(arrDestinatarios) 'indexa o vetor
            For intI As Integer = 0 To intQtd
                If Len(arrDestinatarios(intI)) > 5 And arrDestinatarios(intI) Like "*@*" Then
                    mMailMessage.To.Clear()
                    'define o destinario da mensagem
                    mMailMessage.To.Add(New Net.Mail.MailAddress(arrDestinatarios(intI)))
                    ' Envia o email
                    ' smtp.Timeout = 1800

                    smtp.Send(mMailMessage)

                    For intTemp As Integer = 0 To 1000

                    Next

                End If
            Next

            Return "Mail sent successfully!"

        Catch ex As Exception
            Return "Error: " & ex.Message.ToString
        End Try

    End Function

    Public Function fEnviaEmail_Todos(ByVal strDestinatario As String, ByVal strAssunto As String, ByVal strCorpoMSG As String, ByVal strAnexoCaminho As String, ByVal strResponderPara As String) As String

        Dim arrDestinatarios() As String
        Dim intQtd As Integer

        'cria uma instância do objeto MailMessage
        Dim mMailMessage As New Net.Mail.MailMessage()

        'define o formato do email HTML
        'mMailMessage.IsBodyHtml = True

        'define o endereço do remetente
        mMailMessage.From = New Net.Mail.MailAddress(strContaRemetente)

        'define o endereço de resposta
        mMailMessage.ReplyTo = New Net.Mail.MailAddress(strResponderPara)

        'define o assunto 
        mMailMessage.Subject = strAssunto

        'If Not String.IsNullOrEmpty(strConfirmacaoDeLeitura) Then
        '    'para incluir a msg de email recebido
        '    mMailMessage.Headers.Add("Disposition-Notification-To", strConfirmacaoDeLeitura)
        'End If


        'define o corpo da mensagem
        mMailMessage.Body = strCorpoMSG

        'anexar arquivo
        If Trim(strAnexoCaminho) <> "" Then
            mMailMessage.Attachments.Add(New Net.Mail.Attachment(strAnexoCaminho))
        End If

        Try
            'Cria uma instância de SmtpClient 
            Dim smtp As New Net.Mail.SmtpClient(strSMTP)

            With smtp

                .Credentials = New Net.NetworkCredential(strContaEmail, strContaSenha)
                .Port = 25
                '.EnableSsl = False
                .Timeout = 200000
                '.UseDefaultCredentials = True

            End With

            arrDestinatarios = Split(Replace(strDestinatario, ",", ";"), ";") 'Tranforma o conteudo em Vetor usando o separador ;
            intQtd = UBound(arrDestinatarios) 'indexa o vetor

            mMailMessage.To.Clear()
            For intI As Integer = 0 To intQtd
                If Len(arrDestinatarios(intI)) > 5 And arrDestinatarios(intI) Like "*@*" Then

                    mMailMessage.To.Add(New Net.Mail.MailAddress(arrDestinatarios(intI)))

                End If
            Next

            Try

                smtp.Send(mMailMessage)

            Catch ex As Exception
                Return "Error: " & ex.Message.ToString
            End Try

            Return "Mail sent successfully!"

        Catch ex As Exception
            Return "Error: " & ex.Message.ToString
        End Try

    End Function

End Class
