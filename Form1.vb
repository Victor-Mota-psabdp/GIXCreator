Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Imports System.Xml
Imports System.IO
Imports System.Data.SqlClient
Imports System
Imports System.Text


Friend Class Form1
    Inherits System.Windows.Forms.Form

    'Option Explicit
    '29-2-2008
    '- Billed Date Adicionado
    '1.2 22-04 - Concatena��o PO e Ordem
    '1.2 LCL and FCL INDICATOR
    '13-05 - Inclus�o HTS


    ' inclui um esquema no brasil de AWBDATA - cadu 04/09/2015
    'retirei um PGI - cadu 09/09/2015
    ' inclui o AWBDataBR para qdo for StrPais= Brasil, pegar os dados da tabela courier processo

    Public sqlCnn As New cConexao()
    Public Arquivo As New Scripting.FileSystemObject
    Public strProcesso As String
    'Public RsProcesso As New ADODB.Recordset
    Public StrUltimo As String
    Public blnValido As Boolean
    Public StrErro As String
    Public IntI As Short
    Public strTipo As String
    Public StrPROC As String
    Public ArqLog As New Scripting.FileSystemObject
    Public PesoLiquido As Decimal
    Public PesoBruto As Decimal
    Public StrPais As String
    Public strArgTP As String
    Public glbfltTotalInvoice As Decimal
    Public strConsol As String
    Public strLevisISD As String
    Public strINI As String
    Public strLayout As String
    Public ProcessoDT As New Data.DataTable

    'Public strISD As String

    '30/10/2014
    'Incluido no codigo pra gerar o da LEVIS, precisa mudar o strLayout pra Levis e o strPais =Brasil
    'Coloquei alguns arquivos na ordem pra melhor visualiza��o no codigo

    Private Sub GravaLOG(ByVal strMSG As String)

        Dim oEscrever As System.IO.StreamWriter

        Try
            If Directory.Exists("LOG\") = False Then
                Directory.CreateDirectory("LOG\")
            End If

            oEscrever = New IO.StreamWriter(My.Application.Info.DirectoryPath & "\LOG\LOG_" & DateAndTime.DateString & ".log", True)
            oEscrever.WriteLine(strMSG)
            oEscrever.Close()
        Catch ex As Exception

        End Try

    End Sub


    Private Sub Form1_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        Dim escrever As Object
        'Console.WriteLine("Form1_Load")
        StrPais = "Brasil" 'Argentina, Brasil, Chile
        strTipo = "Original"
        strArgTP = "BDP" 'BDP ' 'SEA

        strLayout = "Smart" 'Smart Levis 

        StrType = "Production" 'Production 'Backup '301, 'ACAS 'ShippingInstruction
        'StrType = "301" 'Production 'Backup '301, 'ACAS

        If StrType = "ShippingInstruction" Then
            strCustomer = "INTTRA"
            strFromIdentifier = "ATL"
            strToIdentifier = "Integration"
        Else
            strCustomer = "DOW"
            strFromIdentifier = "ATL"
            strToIdentifier = "Integration"

        End If



        fltNumeracao = 1

        If Directory.Exists("LOG\") = False Then
            Directory.CreateDirectory("LOG\")
        End If

        IntI = 0
        'escrever = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\Log\XML" & CStr(Month(Now)) & ".Log ", Scripting.IOMode.ForAppending, True)
        escrever = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\Log\XML_" & DateAndTime.DateString & ".Log ", Scripting.IOMode.ForAppending, True)

        escrever.WriteLine("Start Program" & vbTab & CStr(Now))
        escrever.Close()


        If StrType = "301" Then
            StrPais = "Brasil"
            Command1_Click(Command1, New System.EventArgs())
            StrPais = "Argentina"
            Command1_Click(Command1, New System.EventArgs())
            End
        End If

        If StrType = "ACAS" Then
            StrPais = "Brasil"
            Command1_Click(Command1, New System.EventArgs())
            StrPais = "Argentina"
            Command1_Click(Command1, New System.EventArgs())
            End
        End If

        Dim strAssunto As String = String.Empty
        Dim strCorpoMSG As String = String.Empty
        Dim strOBS As String = String.Empty
        Dim Email As New CEnviaEmail
        Dim arqEmail As String
        arqEmail = "email.ini"
        Dim sr As IO.StreamReader = New IO.StreamReader(My.Application.Info.DirectoryPath & "\" & arqEmail, True)
        Email.strContaEmail = sr.ReadLine()
        Email.strContaSenha = sr.ReadLine()
        Email.strSMTP = sr.ReadLine()
        Email.strContaRemetente = sr.ReadLine()

        '**************************************************************************NEW connection***********************************
        sqlCnn.arqINI = "cConexao.ini"

        Select Case StrPais
            Case "Argentina"
                strINI = "cConexaoAR.ini"
                sqlCnn.arqINI = strINI
            Case "Brasil"
                strINI = "cConexaoBR.ini"
                sqlCnn.arqINI = strINI
            Case "Chile"
                strINI = "cConexaoCL.ini"
                sqlCnn.arqINI = strINI

        End Select
        '**************************************************************************end NEW connection***********************************
        'Use it to capture some error
        Command1_Click(Command1, New System.EventArgs())

        Try
            Command1_Click(Command1, New System.EventArgs())
        Catch ex As Exception
            strAssunto = "ERROR -XML_ODS_NET - ERROR - Exchange, Country: " + StrPais
            strCorpoMSG = ex.Message
            strOBS = Email.fEnviaEmail("br.sao.sistemas@bdpint.com", strAssunto, strCorpoMSG, "", "br.sao.sistemas@bdpint.com")
            strCorpoMSG = strCorpoMSG + vbCrLf + "Enviado aos emails: " + "br.sao.sistemas@bdpint.com"
            GravaLOG_Historico(DateTime.Now + " -  " + strAssunto + " -  " + strCorpoMSG)
        End Try

        End

    End Sub
    Private Function Itineraryid(ContainerNumber As String) As String

        Dim sqlCon As New cConexao()
        Dim dtbTemp As New Data.DataTable
        sqlCon.arqINI = "cConexao.ini"

        Select Case StrPais
            Case "Argentina"
                strINI = "cConexaoAR.ini"
                sqlCon.arqINI = strINI
            Case "Brasil"
                strINI = "cConexaoBR.ini"
                sqlCon.arqINI = strINI
            Case "Chile"
                strINI = "cConexaoCL.ini"
                sqlCon.arqINI = strINI

        End Select
        sqlCon.Conectar()

        Itineraryid = ""


        StrSql = "exec spODSIntItineraryiD_Sel '" & strProcesso & "','" & ContainerNumber & "'"
        dtbTemp = sqlCon.BuscaInformacoes(StrSql)
        If dtbTemp.Rows.Count > 0 Then

            Itineraryid = " <References type='ItineraryID'>"
            Itineraryid = Itineraryid + "<ReferenceNumber>" + dtbTemp.Rows(0)("Itinerary_ID").ToString() + "</ReferenceNumber>"
            Itineraryid = Itineraryid + "</References>"
        End If



    End Function
    Private Sub Command1_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Command1.Click
        Dim escrever As Object
        '  Dim ltempDT As New Data.DataTable
        Dim IntI As Decimal
        Dim StrServidor As String
        Dim StrSenha As String
        Dim StrUsuario As String
        Dim StrBase As String
        Dim sqlCon As New cConexao()
        Dim tempDT As New Data.DataTable

        'Console.WriteLine("Command1_Click")

        'On Error GoTo Final


        Select Case StrPais
            Case "Argentina"
                strINI = "cConexaoAR.ini"
                sqlCon.arqINI = strINI
                If strArgTP = "SEA" Then
                    StrBase = "ATL_SB"
                End If
            Case "Brasil"
                strINI = "cConexaoBR.ini"
                sqlCon.arqINI = strINI
                'sqlCon.CredSQLInf.SQLUser = "ATLPROD"
                'sqlCon.CredSQLInf.SQLPassword = "AtlProd@123"
                'sqlCon.CredSQLInf.Servidor = "WUSPBDPNODE04\WUSPBDPSQL04"
            Case "Chile"
                strINI = "cConexaoCL.ini"
                sqlCon.arqINI = strINI
                sqlCon.Conectar()
        End Select

        '#warning CADU
        sqlCnn.arqINI = sqlCon.arqINI

        StrBase = "ATLANTIS"
        sqlCon.Conectar()
        StrServidor = sqlCon.CredSQLInf.Servidor
        StrBase = sqlCon.CredSQLInf.DB
        StrUsuario = sqlCon.CredSQLInf.SQLUser
        StrSenha = sqlCon.CredSQLInf.SQLPassword


        'StrSql = "spBuscaProcessos_ODS_desc_Sel"
        StrSql = "spBuscaProcessos_ODS_Sel"
        'StrSql = "select distinct num_proc processo from atl_int.dbo.smart_xml where num_proc like  'IMCTV202512259BR'"
        'StrSql = "select distinct Num_Proc_HEM Processo from Container_Hou_Exp_Mar where Num_Proc_HEM like ('EMCOR2019%')"
        'StrSql = "select 'EMCSR202304127BR' processo union ALL select 'EMCSR202304127BR' processo"
        'StrSql = "select Num_Proc processo from vwHouse_IMp where Num_proc like 'IMLVS2023%'"
        'StrSql = "select 'EMATL202407001BR' processo"

        If Trim(StrPROC) <> "" Then

            If StrPais = "Brasil" Then

                Select Case VB.Left(StrPROC, 2)
                    Case "IA"
                        StrSql = "select 'IACSR20080100201' Processo"
                    Case "IM"
                        StrSql = "select 'IMTYC201503001BR' Processo"
                    Case "IO"
                        StrSql = "select 'IMCSR20080100301' Processo"
                    Case "EA"
                        StrSql = "select 'EACSR20080100101' Processo"
                    Case "EO"
                        StrSql = "select 'EOCSR20080100601' Processo"
                    Case "EM"
                        StrSql = "select 'EMCSR20080100101' Processo"
                End Select

            End If

            If StrPais = "Argentina" Then

                Select Case VB.Left(StrPROC, 2)
                    Case "IA"
                        StrSql = "select 'IACSR20080100201' Processo"
                    Case "IM"
                        StrSql = "select 'IMARG20080800101' Processo"
                    Case "IO"
                        StrSql = "select 'IOARG20080800101' Processo"
                    Case "EA"
                        StrSql = "select 'EAARG20081000201' Processo"
                    Case "EO"
                        StrSql = "select 'EOARG20080801301' Processo"
                    Case "EM"
                        StrSql = "select 'EMARG20081017701' Processo"
                End Select

            End If

            If UCase(StrPais) = "CHILE" Then
                Select Case VB.Left(StrPROC, 2)
                    Case "IA"
                        StrSql = "select 'IOCHL20090500101' Processo"
                    Case "IM"
                        StrSql = "select 'IMCHL20090500101' Processo"
                    Case "IO"
                        StrSql = "select 'IOCHL20090500101' Processo"
                    Case "EA"
                        StrSql = "select 'EAARG20081000201' Processo"
                    Case "EO"
                        StrSql = "select 'EOARG20080801301' Processo"
                    Case "EM"
                        StrSql = "select 'EMARG20081017701' Processo"
                End Select
            End If

        End If
        If StrType = "Backup" Then
            StrSql = "spSmartBKP_INT '07-01-2012','07-31-2012'"
        End If

        If strLayout = "Levis" Then
            StrSql = "spATL_XMLLEVISBusca_Sel"
        End If

        If StrType = "ShippingInstruction" Then
            StrSql = "spATL_Exchange_GTNexus_Sel NULL,'','SI','A'"
            ' StrSql = "select E.ID [ID],E.Num_Proc [Processo] from dbo.Exchange_GTNexus E with(nolock)	where E.Type = 'SI'	and E.Dt_send is null"
        End If

        If StrType = "301" Then
            StrSql = "spInt301_Sel"
            'StrSql = "spInt301_New_Sel"
            'StrSql = "select 'EMCSR202209103BR' processo,'38207761' BuyerReference"
            'StrSql = "select 'EMARG202101090AR' processo,'38147089' BuyerReference union all select'EMARG202101109AR' processo,'38147089' BuyerReference union all select'EMARG202101002AR' processo,'38147089' BuyerReference union all select'EMARG202101072AR' processo,'38147089' BuyerReference"
            'StrSql = "select 'EMECP201903001BR' Processo"
            'StrSql = "select 'EMARG202101196AR' processo,'38259452' BuyerReference union all select'EMARG202101178AR' processo,'38225321' BuyerReference"
            'StrSql = "spInt301_ECP_Teste_Sel"
            ' StrSql = "spInt301_Teste_Sel"
        End If

        If StrType = "ACAS" Then
            StrSql = "spBuscaProcessoACASINT_Sel"
        End If

        If strTipo = "Cancel" Then
            StrSql = "Select '" + StrPROC + "' Processo"
        End If

        '  ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        'STO INd Test
        'StrSql = "select 'EMCSR202102001BR' processo union all select 'EMCSR202102002BR' processo "
        'StrSql = "select 'EMARG202102001AR' processo union all select 'EMARG202102002AR' processo "

        'StrSql = "SELECT Num_Proc_HEM Processo from House_Exp_Mar where Num_Proc_HEM in ('EMCSR202302102BR','EMCSR202302103BR','EMCSR202302104BR')"
        'StrSql = "SELECT Num_Proc_HEM Processo from House_Exp_Mar where Num_Proc_HEM in ('EMCSR202304010BR')"
        'StrSql = "SELECT Num_Proc Processo from vwHouse_Imp where Num_Proc in 
        '            ('IAFLT202301008AR',
        '            'IAFLT202301009AR',
        '            'IAFLT202301010AR',
        '            'IAFLT202301012AR',
        '            'IAFLT202301013AR',
        '            'IAFLT202301017AR')"
        'StrSql = "select 'IMSCH202009035BR' processo 
        'union all select 'IMSCH202009033BR' processo 
        'union all select 'IMSCH202008023BR ' processo
        'union all select 'EMCSR202011049BR' processo
        'union all select 'EMCSR202011051BR' processo"
        'StrSql = "select Num_Proc Processo, Numero_PO BuyerReference from vwPO_ALL where Num_Proc in ('EMCSR202102070BR','EMCSR202102060BR','EMCSR202102075BR','EMCSR202102078BR','EMCSR202102080BR') and id_dc = 8"

        'StrSql = "select Num_Proc Processo, Numero_PO BuyerReference from vwPO_ALL where Num_Proc in
        '        ('EMCSR202102001BR','EMCSR202102002BR','EMARG202102001AR','EMARG202102002AR') 
        '        and id_dc = 8"

        'StrSql = "select Distinct PS.Num_Proc Processo, 
        '			(case when CO3.campo_dados is not null then
        '				(case when CO26.campo_dados = 'Y' then CO26.campo_dados else 'N' end)			
        '				else NULL end) [STO Indicator] 
        '			from Pedido_Ship PS with(nolock)
        '			Join  campo_ordem CO3 with(nolock) on PS.cd_pedido=CO3.cd_pedido and CO3.id_campo=3
        '			left Join campo_ordem CO26 with(nolock) on PS.cd_pedido=CO26.cd_pedido and CO26.id_campo=26
        '			where  CO3.id_campo=3
        '			and CO3.Dt_Ins_Upd> '2021-03-25'"
        'StrSql = "select distinct num_proc processo from Smart_XML where num_proc like 'EMARG2021%' and dt_envio > '2021-03-25'"
        'StrSql = "select num_proc processo from vwALL_JOBs where Num_Proc in ('IMCTV202512259BR') "
        tempDT = sqlCon.BuscaInformacoes(StrSql)
        GravaLOG("Start Qty: " + tempDT.Rows.Count.ToString() + " Date: " + DateTime.Now)

        'Gera_Arquivos("IMSCH202007004AR")
        'Gera_Arquivos("IMSCH202007001AR")
        'Gera_Arquivos("IMSCH202007004AR")
        '  Gera_Arquivos("IMSCH202006001BR")

        IntI = 1

        For Each tempDR As Data.DataRow In tempDT.Rows

            strProcesso = tempDR.Item("processo").ToString()

            GravaLOG(DateTime.Now + " - " + strProcesso)

            If Verifica_Arquivo(strProcesso) = True Then
                'If Right(Left(RsTemp!processo, 5), 3) = "CLI" Or Right(Left(RsTemp!processo, 5), 3) = "FMC" Or Right(Left(RsTemp!processo, 5), 3) = "CSR" Or Right(Left(RsTemp!processo, 5), 3) = "ARG" Or Right(Left(RsTemp!processo, 5), 3) = "MSF" Then
                fltNumeracao = fltNumeracao + 1
                If strLayout.Equals("Levis") Then
                    StrErro = Verifica_Regras_Levis()

                    If StrErro.Equals("") Then
                        strLevisISD = tempDR.Item("BuyerReference").ToString()
                        Gera_Arquivos((tempDR.Item("processo").ToString()))
                        StrSql = "spExchangeLevis_Upd '" + tempDR.Item("processo").ToString() + "','L'"
                        sqlCnn.ExecutaComando(StrSql)

                    Else
                        StrSql = "insert into Levis_Log_Erro values('" & strProcesso & "',getdate(),null,'" & "Arquivo n�o gerado, Falta os Dados da :" & StrErro.ToString() & "')"
                        sqlCnn.ExecutaComando(StrSql)
                    End If
                Else
                    If StrType = "301" Then
                        strLevisISD = tempDR.Item("BuyerReference").ToString()
                        Gera_Arquivos((tempDR.Item("processo").ToString()))
                        'StrSql = "insert EDI301(num_proc,dt_envio) values('" + lTempDT.Rows(0)("processo").toString() + "',getdate())"
                        StrSql = "spExchange301_Upd '" + tempDR.Item("processo").ToString() + "','L'"
                        sqlCnn.ExecutaComando(StrSql)

                    ElseIf StrType = "ShippingInstruction" Then
                        strLevisISD = tempDR.Item("Id").ToString()
                        Gera_Arquivos((tempDR.Item("processo").ToString()))
                        StrSql = "spExchange_GTNexus_Upd '" + tempDR.Item("processo").ToString() + "','" + strLevisISD + "','SI'"
                        sqlCnn.ExecutaComando(StrSql)

                    Else
                        Gera_Arquivos((tempDR.Item("processo").ToString()))

                        If StrType <> "Backup" And StrType <> "301" Then
                            'StrSql = "spExchange_Upd '" + lTempDT.Rows(0)("processo").toString() + "','X'"
                            'Conexao.Execute(StrSql)
                            Dim strHistorico As Boolean
                            strHistorico = Save_Exchange(tempDR.Item("processo").ToString(), "X", strINI)
                            While strHistorico = False
                                strHistorico = Save_Exchange(tempDR.Item("processo").ToString(), "X", strINI)
                            End While
                        End If

                        If StrType = "ACAS" Then
                            StrSql = "insert Exchange_ACAS(num_proc,dt_envio) values('" + tempDR.Item("processo").ToString() + "',getdate())"
                            sqlCnn.ExecutaComando(StrSql)

                        End If
                    End If
                End If

            End If
            'Threading.Thread.Sleep(18000)
            'While IntI <= 999999
            '    IntI = IntI + 1
            'End While
            'IntI = 0

        Next



        GravaLOG("End Qty: " + tempDT.Rows.Count.ToString() = "Date: " + DateTime.Now)
        'lblStatus.Text = CStr(Now)
        'escrever = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\Log\XML" & CStr(Month(Now)) & ".log", Scripting.IOMode.ForAppending, True)
        escrever = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\Log\XML_" & DateAndTime.DateString & ".Log ", Scripting.IOMode.ForAppending, True)

        escrever.WriteLine("Program has been finished" & vbTab & vbTab & CStr(Now))
        escrever.Close()

        '  Lista_Processos_ER
        'Final:
        '        If Trim(Err.Description) <> "" Then
        '            escrever = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\Log\Error_" & CStr(Month(Now)) & ".log", Scripting.IOMode.ForAppending, True)
        '            escrever.WriteLine(" Erro on execution " & vbTab & strProcesso & vbTab & Err.Description & vbTab & CStr(Now))
        '            EmailErro("Erro on execution " & vbTab & strProcesso & vbTab & Err.Description & vbTab & CStr(Now))
        '            Err.Description = ""
        '            End
        '        End If

    End Sub

    Private Function Save_Exchange(ByVal strJob As String, ByVal strTipo As String, ByVal strArqINI As String) As Boolean

        Dim Email As New CEnviaEmail
        Dim arqEmail As String
        arqEmail = "email.ini"
        Dim sr As IO.StreamReader = New IO.StreamReader(My.Application.Info.DirectoryPath & "\" & arqEmail, True)
        Email.strContaEmail = sr.ReadLine()
        Email.strContaSenha = sr.ReadLine()
        Email.strSMTP = sr.ReadLine()
        Email.strContaRemetente = sr.ReadLine()

        Dim strAssunto As String = String.Empty
        Dim strCorpoMSG As String = String.Empty
        Dim strOBS As String = String.Empty

        Dim strHistorico As Boolean = True

        Dim sqlCon As New cConexao()
        sqlCon.arqINI = strArqINI
        sqlCon.Conectar()
        'Classe para Conex�o ao SQL
        'StrSql = "spExchange_Upd '" + lTempDT.Rows(0)("processo").toString() + "','X'"
        Dim sqlCMD As SqlCommand
        GravaLOG_Historico(DateTime.Now & " - Inserir Historico " & strJob)
        sqlCMD = New SqlCommand("spExchange_Upd", sqlCon.cnn)
        sqlCMD.CommandTimeout = 0
        sqlCMD.CommandType = Data.CommandType.StoredProcedure
        sqlCMD.Parameters.Add("@Num_Proc", SqlDbType.VarChar).Value = strJob
        sqlCMD.Parameters.Add("@Tipo", SqlDbType.Char).Value = strTipo
        Try
            sqlCMD.ExecuteNonQuery()
            GravaLOG_Historico(DateTime.Now & " - Insert with success " & strJob)
        Catch
            strAssunto = "ERRO - Rotina: XML ODS Save Exchange - " & strJob & " - ERRO - Exchange"
            strCorpoMSG = StrSql
            strOBS = Email.fEnviaEmail("br.sao.sistemas@bdpint.com", strAssunto, strCorpoMSG, "", "br.sao.sistemas@bdpint.com")
            strCorpoMSG = strCorpoMSG + vbCrLf + "Enviado aos emails: " + "br.sao.sistemas@bdpint.com"
            GravaLOG_Historico(DateTime.Now + " -  " + strAssunto + " -  " + strCorpoMSG)
            strHistorico = False
        End Try

        Return strHistorico

    End Function

    Private Sub GravaLOG_Historico(ByVal strMSG As String)

        Dim oEscrever As System.IO.StreamWriter

        Try
            If Directory.Exists("LOG\") = False Then
                Directory.CreateDirectory("LOG\")
            End If

            oEscrever = New IO.StreamWriter(My.Application.Info.DirectoryPath & "\LOG\LOG_Historico_" & DateAndTime.DateString & ".log", True)
            oEscrever.WriteLine(strMSG)
            oEscrever.Close()
        Catch ex As Exception

        End Try

    End Sub

    Private Sub EmailErro(ByVal strMSG As String)
        Dim strAnexo As String
        Dim Email As New CEnviaEmail
        Dim arqEmail As String
        arqEmail = "email.ini"
        Dim sr As IO.StreamReader = New IO.StreamReader(My.Application.Info.DirectoryPath & "\" & arqEmail, True)
        Email.strContaEmail = sr.ReadLine()
        Email.strContaSenha = sr.ReadLine()
        Email.strSMTP = sr.ReadLine()
        Email.strContaRemetente = sr.ReadLine()
        strMSG = "Erro on execution " & vbTab & strProcesso & vbTab & Err.Description & vbTab & CStr(Now)
        strAnexo = Email.fEnviaEmail("br.sao.sistemas@bdpint.com", StrPais & " - Erro na rotina XML_ODS", strMSG, "", "br.sao.sistemas@bdpint.com")
        strMSG = strMSG + vbCrLf + "Enviado aos emails: " + "br.sao.sistemas@bdpint.com"
    End Sub

    Private Sub Gera_Arquivos(ByRef StrPROC As String)
        'Dim ReconcLog As Object
        'Dim escrever As Object
        Dim tstream As String
        Dim IntI As Decimal
        Dim StrCdPais As String
        'Console.WriteLine("Gera_Arquivos")

        IntI = 0
        strProcesso = StrPROC

        '       If Arquivo.FileExists(App.Path & "\*.xml") Then
        'Arquivo.DeleteFile App.Path + "\*.xml"
        '      End If
        'RsProcesso = Nothing
        StrSql = "spProcesso_Sel '" & strProcesso.ToString() & "'"
        '2020-11-11  RsProcesso.Open(StrSql, Conexao, ADODB.CursorTypeEnum.adOpenForwardOnly, ADODB.LockTypeEnum.adLockReadOnly)


        ProcessoDT = sqlCnn.BuscaInformacoes(StrSql)


        If Verifica_Localidades() = False Then
            Exit Sub
        End If
        If StrType = "ACAS" Then
            If ACASVerifica() = False Then Exit Sub
        End If

        While StrUltimo = "BDPBRSAO_" & System.DateTime.Now.ToString("yyyyMMddhhmmss") & "0000" & System.DateTime.Now.ToString("ss") & "_01" & ".xml"
            IntI = IntI + 1
        End While

        If IsDBNull(ProcessoDT.Rows(0)("cd_org")) = True Then
            Exit Sub
        End If

        Select Case StrPais
            Case "Brasil"
                If strLayout = "Levis" Then
                    StrUltimo = strProcesso.ToString() & "_" & VB6.Format(Now, "yyyymmddhhmmss") & ".xml"
                Else
                    StrUltimo = "BDPBRSAO_" & VB6.Format(Now, "yyyymmddhhmmss") & VB.Right("000000" & CStr(fltNumeracao), 6) & "_01" & ".xml"
                End If
                StrCdPais = "BR"

            Case "Argentina"
                StrUltimo = "BDPARBUE_" & VB6.Format(Now, "yyyymmddhhmmss") & VB.Right("000000" & CStr(fltNumeracao), 6) & "_01" & ".xml"
                StrCdPais = "AR"
            Case "Chile"
                StrUltimo = "BDPCLSCL_" & VB6.Format(Now, "yyyymmddhhmmss") & VB.Right("000000" & CStr(fltNumeracao), 6) & "_01" & ".xml"
                StrCdPais = "CL"
        End Select
        If StrType = "301" Then
            'StrUltimo = "ELEMECA_301_" & VB6.Format(Now, "yyyymmddmmssSS") & ".OUT"
            StrUltimo = "ELEMECA_301_" & DateTime.Now.ToString("yyyyMMddhhmmss") & ".OUT"
        End If
        If StrType = "ACAS" Then
            Select Case StrPais
                Case "Brasil"
                    StrUltimo = "BDPBRSAO_" & VB6.Format(Now, "yyyymmddhhmmss") & VB.Right("000000" & CStr(fltNumeracao), 6) & "_01" & ".xml"
                    StrCdPais = "BR"
                Case "Argentina"
                    StrUltimo = "BDPARBUE_" & VB6.Format(Now, "yyyymmddhhmmss") & VB.Right("000000" & CStr(fltNumeracao), 6) & "_01" & ".xml"
                    StrCdPais = "AR"
                Case "Chile"
                    StrUltimo = "BDPCLSCL_" & VB6.Format(Now, "yyyymmddhhmmss") & VB.Right("000000" & CStr(fltNumeracao), 6) & "_01" & ".xml"
                    StrCdPais = "CL"
            End Select
        End If


        'tstream = tstream +Arquivo.CreateTextFile(My.Application.Info.DirectoryPath & "\" & StrUltimo)
        '    flx.AddItem(("BDPBRSAO_" & Now.ToString("yyyymmddhhmmss") & "000021" & ".xml" & vbTab & StrPROC))

        If ProcessoDT.Rows.Count = 0 Then
            Exit Sub
        End If
        'CABECALHO


        If ProcessoDT.Rows(0)("Job_Status").ToString() = "" Then
            strTipo = "Original"
        Else
            If ProcessoDT.Rows(0)("Job_Status").ToString().Substring(0, 1) = "9" Then
                strTipo = "Cancel"
            Else
                strTipo = "Original"
            End If
        End If




        tstream = Inicio()

        '   tstream.WriteLine (DeliveryTranPartner(StrPROC))
        'Consignee

        tstream = tstream + Pessoa("Consignee", ProcessoDT.Rows(0)("cd_consig").ToString())

        'Cognos/ODS - Load Creation Template - BDP Smart Terra/Smart X
        tstream = tstream + Pessoa("DeliverTo", ProcessoDT.Rows(0)("cd_consig").ToString())

        If StrType.Equals("ShippingInstruction") = False Then
            '   Exporter
            tstream = tstream + Pessoa("Exportador", ProcessoDT.Rows(0)("cd_Export").ToString())

            'Cognos/ODS - Load Creation Template - BDP Smart Terra/Smart X
            tstream = tstream + Pessoa("ShipFrom", ProcessoDT.Rows(0)("cd_Export").ToString())


            'Ship to
            tstream = tstream + Pessoa("ShipTo", ProcessoDT.Rows(0)("cd_consig").ToString())

            ''Sold to
            'tstream = tstream + Pessoa("Soldto", ProcessoDT.Rows(0)("cd_consig").toString())

            'Sold to
            If StrPais <> "Chile" Then
                If Not (String.IsNullOrEmpty(Busca_SoldTo(strProcesso.ToString()))) Then
                    tstream = tstream + Busca_SoldTo(strProcesso.ToString())
                Else
                    tstream = tstream + Pessoa("Soldto", ProcessoDT.Rows(0)("cd_consig").ToString())
                End If
            Else
                tstream = tstream + Pessoa("Soldto", ProcessoDT.Rows(0)("cd_consig").ToString())
            End If

        End If

        'Notify
        tstream = tstream + Pessoa("Notify", ProcessoDT.Rows(0)("cd_notify").ToString())
        'AlsoNotify

        'CSR - utilizado para exporta��es a�reas

        tstream = tstream + OfficeDeOrigem()


        'Partner
        tstream = tstream + Partner()

        If StrType.Equals("ShippingInstruction") = False Then
            'Desabilitado por Anderson 05/12/2014
            'Plant
            If VB.Left(strProcesso, 1) = "E" Then

                tstream = tstream + Pessoa("Plant", ProcessoDT.Rows(0)("cd_Export").ToString())
            Else

                tstream = tstream + Pessoa("Plant", ProcessoDT.Rows(0)("cd_consig").ToString())
            End If
            'Fim 05/12/2014

            'tstream = tstream + Plant()


            'BDPRepreentative
            Select Case StrPais
                Case "Argentina"

                    tstream = tstream + Pessoa("BDPRepresentative", "P15498")
                Case "Brasil"
                    tstream = tstream + Plant()

                    tstream = tstream + Pessoa("BDPRepresentative", "10017")
                Case "Chile"

                    tstream = tstream + Pessoa("BDPRepresentative", "P10050")
            End Select
        End If

        'ClearingAgent
        If IsDBNull(ProcessoDT.Rows(0)("cd_despachante")) = False And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I" Then
            ' tstream.WriteLine (Pessoa("ClearingAgent", RsProcesso!cd_despachante))

            Select Case StrPais
                Case "Argentina"

                    tstream = tstream + Pessoa("ClearingAgent", "P15498")
                Case "Brasil"

                    tstream = tstream + Pessoa("ClearingAgent", "10017")

                    tstream = tstream + Pessoa("ClearingAgent", "P10050")
            End Select

        End If

        If StrType.Equals("ShippingInstruction") = False Then

            'Buyer
            tstream = tstream + Pessoa("Buyer", ProcessoDT.Rows(0)("cd_consig").ToString())

            'Global Agent
            If GlobalAgent() <> "" Then tstream = tstream + GlobalAgent()

            'Buyer
            tstream = tstream + Pessoa("Importer", ProcessoDT.Rows(0)("cd_consig").ToString())

            'Forwarder
            '      tstream.WriteLine (Forwarder)

            If IsDBNull(ProcessoDT.Rows(0)("cd_forwarder")) = False Then
                tstream = tstream + Pessoa("Forwarder", ProcessoDT.Rows(0)("cd_forwarder").ToString())
            End If

            'Seller
            tstream = tstream + Pessoa("Seller", ProcessoDT.Rows(0)("cd_Export").ToString())

            'Supplier
            tstream = tstream + Pessoa("Supplier", ProcessoDT.Rows(0)("cd_Export").ToString())
        End If

        If StrType.Equals("ShippingInstruction") Then
            tstream = tstream + Pessoa("ExporterShipper", ProcessoDT.Rows(0)("cd_Export").ToString())
            tstream = tstream + Pessoa("Shipper", ProcessoDT.Rows(0)("cd_Export").ToString())
            tstream = tstream + ForwarderSI()
            If CarrierAgntNewPrty("Carrier", strProcesso) <> "" Then tstream = tstream + CarrierAgntNewPrty("Carrier", strProcesso)
            If CarrierAgntNewPrty("CarrierAgntNewPrty", strProcesso) <> "" Then tstream = tstream + CarrierAgntNewPrty("CarrierAgntNewPrty", strProcesso)
        End If


        'Processing

        tstream = tstream + Process_Instruction()

        'Transportador de Entrega
        'tstream.WriteLine (DeliveryTransportation(StrPROC))

        'BDP JOB

        tstream = tstream + BDPJobNumber()

        'ImprtLicNeededInd
        Select Case StrPais
            Case "Brasil"

                tstream = tstream + ImprtLicNeededInd()
        End Select

        'CourierAWB
        'Alterado por Erbson 16-09-2015: Retirado para atender o ticket 100-31063 
        'tstream = tstream + CourierAWBReferences()
        'OperatingUnitClassification

        tstream = tstream + OperatingUnitClassification()


        'SellerCode

        tstream = tstream + SellerCode()

        'Shiping

        tstream = tstream + Shipment()
        'Shiping

        tstream = tstream + SAPShipment()

        'Invoice

        If Invoice_Number() <> "" Then tstream = tstream + Invoice_Number()

        'DI - 31/01
        If DI_Number() <> "" Then tstream = tstream + DI_Number()


        'GeneralDescription
        If GeneralDescription() <> "" Then tstream = tstream + GeneralDescription()



        'CustomsEntryNumber
        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I" Then

            If CustomsEntryNumber() <> "" Then tstream = tstream + CustomsEntryNumber()
        End If
        'GovernmentPermissionToExportReleaseNumber

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "E" Then

            tstream = tstream + GovernmentPermissionToExportReleaseNumber()
        End If
        'GovernmentPermissionToExportSubmissionNumber
        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "E" Then

            tstream = tstream + GovernmentPermissionToExportSubmissionNumber()
        End If


        'PO

        If PO() <> "" Then tstream = tstream + PO()

        'Order Number

        If SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "OrderNumber") <> "" Then tstream = tstream + SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "OrderNumber")

        'OrderType

        If OrderType(ProcessoDT.Rows(0)("processo").ToString()) <> "" Then tstream = tstream + OrderType(ProcessoDT.Rows(0)("processo").ToString())
        'DeliveryOrderNumber

        If DeliveryOrderNumber(ProcessoDT.Rows(0)("processo").ToString()) <> "" Then tstream = tstream + DeliveryOrderNumber(ProcessoDT.Rows(0)("processo").ToString())


        'SellerReferenceNumber

        If SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "SellerReferenceNumber") <> "" Then tstream = tstream + SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "SellerReferenceNumber")
        'XITNNumber

        If XITNNumber() <> "" Then tstream = tstream + XITNNumber()
        'ExportEIN
        'TStream.WriteLine (ExportEIN)
        'BDPCliente

        tstream = tstream + BDPCliente()
        'Hazardous

        tstream = tstream + Hazardous()
        'CargoType

        tstream = tstream + CargoType()

        'ManifestHoldIndYN

        tstream = tstream + ManifestHoldIndYN()
        'CustomsEntrytypeCode
        'Regra Inserida por Erbson 19/08/2015 - N�o utilizar par ao 301
        If (StrType.Equals("301") = False) Then
            tstream = tstream + CustomsEntrytypeCode(ProcessoDT.Rows(0)("processo").ToString())
        End If
        'CountryOfExportUNLOCCode

        tstream = tstream + CountryReferences(ProcessoDT.Rows(0)("cd_org").ToString(), "CountryOfExportUNLOCCode")
        'BDPBillingInvoiceNumber

        tstream = tstream + BDPBillingInvoiceNumber()
        'BuyerReferenceNumber

        'tstream = tstream + BuyerReferenceNumber()

        'If strLayout.Equals("Levis") Then
        'tstream = tstream + BuyerReferenceNumberLevis()
        'Else
        tstream = tstream + BuyerReferenceNumber()
        'End If
        'DestinationControlIndYN

        tstream = tstream + DestinationControlIndYN()
        'SupplierRelatedNonrelatedUndYN

        tstream = tstream + SupplierRelatedNonrelatedUndYN()
        'ConsolIndicator

        tstream = tstream + ConsolIndicator()

        'Valida��o US - Anderosn 26/02/2013

        '        tstream.WriteLine (BDPTransportYN)
        '        tstream.WriteLine (CarrierContractNbr)
        '        tstream.WriteLine (InsightRefNum)

        tstream = tstream + BDPTransportYN()

        'ConsolidationNumber

        tstream = tstream + ConsolidationNumber()
        'ConsolStatus

        tstream = tstream + ConsolStatus()
        'ExpressMBOLInd

        tstream = tstream + ExpressMBOLInd()
        'BookingNumber
        tstream = tstream + BookingNumber()

        If StrType.Equals("ShippingInstruction") Then
            tstream = tstream + BookingNumberSI()
            tstream = tstream + CarrierContractNbrSI()
            tstream = tstream + MasterBillOfLadingSI()
            tstream = tstream + Forwarder_Reference_NumberSI()
            tstream = tstream + Shipper_Reference_NumberSI()
        End If

        'SupplierReference
        If SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "SupplierReference") <> "" Then tstream = tstream + SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "SupplierReference")
        'HouseCarrierSCAC
        'tstream.WriteLine (HouseCarrierSCAC)

        'ExportForwarderRefNbr

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I" Then

            tstream = tstream + ImportForwarderRefNbr()
        Else

            tstream = tstream + ExportForwarderRefNbr()
        End If

        'ShipmentStatus

        tstream = tstream + ShipmentStatus()

        'Seller

        If SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "SalesOrderNumber") <> "" Then tstream = tstream + SellerRef(ProcessoDT.Rows(0)("processo").ToString(), ProcessoDT.Rows(0)("processo").ToString(), "A", "SalesOrderNumber")


        'STOInd

        'If String.Compare(StrType, "301", True) = 0 Then
        tstream = tstream + STOInd()
        'End If

        'HBL
        If HouseBillOfLading() <> "" Then tstream = tstream + HouseBillOfLading()

        'ForwarderInstructions      

        tstream = tstream + ForwarderInstructions()
        'Incoterm

        tstream = tstream + Invoice()

        'Transportation

        tstream = tstream + Transportation_PlaceofDelivery()
        'Transportation

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IM" Then tstream = tstream + Transportation_PortofEntry()

        'Transportation

        tstream = tstream + Transportation()

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M", "A"
                'Container
                tstream = tstream + Container_Renamed()
                'Container_Detalhe

                If Container_DET() <> "" Then tstream = tstream + Container_DET()
        End Select
        'Carta de Credito
        tstream = tstream + CartaCredito(ProcessoDT.Rows(0)("processo").ToString())

        'License
        If StrPais <> "Chile" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IM" Then
            Dim L As String
            L = License(ProcessoDT.Rows(0)("processo").ToString())
            tstream = tstream + License(ProcessoDT.Rows(0)("processo").ToString())
        End If

        'Marks
        tstream = tstream + Marks()



        If EstimatedPlaceofReceiptDate() <> "" Then tstream = tstream + EstimatedPlaceofReceiptDate()


        If ActDeliveryDate() <> "" Then tstream = tstream + ActDeliveryDate()


        If ActDestinationDeliveryDate() <> "" Then tstream = tstream + ActDestinationDeliveryDate()
        'BillofLadingBackDate

        If BillofLadingBackDate() <> "" Then tstream = tstream + BillofLadingBackDate()
        If strConsol = "Y" Then


            tstream = tstream + ConsolETADate()

            tstream = tstream + ConsolFreightArrivalDate()

            tstream = tstream + ConsolFreightDeliveryDate()

            tstream = tstream + MstActPortofDepartureDate()

            tstream = tstream + MstEstPortofDepartureDate()

            tstream = tstream + MstActPortofArrivalDate()

            tstream = tstream + MstEstPortofArrivalDate()


            tstream = tstream + ConsolOpenedDate()

            tstream = tstream + ConsolDocsRcvddate()

            tstream = tstream + ConsolPostedDate()


        End If

        'ATA

        tstream = tstream + ATA()
        'DateSailingConfirmed

        If DateSailingConfirmed() <> "" Then tstream = tstream + DateSailingConfirmed()
        'ActPlaceOfDeliveryDate

        If ActPlaceOfDeliveryDate() <> "" Then tstream = tstream + ActPlaceOfDeliveryDate()
        'EstDomesticInlandDeliveryDate

        If EstDomesticInlandDeliveryDate() <> "" Then tstream = tstream + EstDomesticInlandDeliveryDate()

        'ActPlaceOfReceiptDate

        If ActPlaceOfReceiptDate() <> "" Then tstream = tstream + ActPlaceOfReceiptDate()
        'ActUnloadedFromVesselDate

        If ActUnloadedFromVesselDate() <> "" Then tstream = tstream + ActUnloadedFromVesselDate()

        'ActCustomsPortDate

        If ActCustomsPortDate() <> "" Then tstream = tstream + ActCustomsPortDate()

        If (StrCdPais.Equals("BR")) Then
            If BkngCnfrmtnRcvdSS() <> "" Then tstream = tstream + BkngCnfrmtnRcvdSS()
        End If


        'ActPortOfExitDate
        If ActPortOfExitDate() <> "" Then tstream = tstream + ActPortOfExitDate()
        'BillofLadingRetreivedDate

        If BillofLadingRetreivedDate() <> "" Then tstream = tstream + BillofLadingRetreivedDate()
        'DocsRcvdDateEM

        If DocsRcvdDateEM() <> "" Then tstream = tstream + DocsRcvdDateEM()
        'ActVesselDepartureDate

        If TagsATDM("ActVesselDepartureDate") <> "" Then tstream = tstream + TagsATDM("ActVesselDepartureDate")
        'EstPortOfExitDate

        If EstPortOfExitDate() <> "" Then tstream = tstream + EstPortOfExitDate()
        'LoadedOnVessel

        If TagsATDM("LoadedOnVessel") <> "" Then tstream = tstream + TagsATDM("LoadedOnVessel")

        'LiquidationDate

        tstream = tstream + LiquidationDate()
        'GovernmentPaymentStatementPaymentDate

        tstream = tstream + GovernmentPaymentStatementPaymentDate()


        'ActPortofDepartureDate

        If TagsATDM("ActPortofDepartureDate") <> "" Then tstream = tstream + TagsATDM("ActPortofDepartureDate")

        'ETD

        If VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1) <> "A" Then tstream = tstream + ETD()
        'ETA

        If ETA() <> "" Then tstream = tstream + ETA()

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then tstream = tstream + Original_ETA()
        'BOLActionDate

        If BOLActionDate() <> "" Then tstream = tstream + BOLActionDate()
        'ActCityOfExitDate

        If ActCityOfExitDate() <> "" Then tstream = tstream + ActCityOfExitDate()
        'ActDocumentDistributionSentDate

        If ActDocumentDistributionSentDate() <> "" Then tstream = tstream + ActDocumentDistributionSentDate()
        'ActCityOfOriginDate

        If ActCityOfOriginDate() <> "" Then tstream = tstream + ActCityOfOriginDate()
        'Billing Date

        If Trim(Billing_Date) <> "" Then tstream = tstream + Billing_Date()
        'EstimatedTimeofDepartureDate

        If EstimatedPortofEntryDate() <> "" Then tstream = tstream + EstimatedPortofEntryDate()
        'MbolMawbIssueDate
        ' Request change by Anderson - 06/03/2018
        If MbolMawbIssueDate() <> "" Then tstream = tstream + MbolMawbIssueDate()
        'ActualTimeofDepartureDate
        ' Request change by Anderson - 06/03/2018
        If ActualPortofEntryDate() <> "" Then tstream = tstream + ActualPortofEntryDate()
        'EstCityOfDischargeArrivalDate

        tstream = tstream + EstCityOfDischargeArrivalDate()
        'BLACtion Date

        tstream = tstream + BLActionDate()
        'ActBookingConfirmationDate

        If Trim(ActBookingConfirmationDate) <> "" Then tstream = tstream + ActBookingConfirmationDate()
        'RequestedETADestinationDate

        tstream = tstream + RequestedETADestinationDate()
        'EstimatedAIRPortofEntryDate

        'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Then tstream = tstream + EstimatedAirportofEntryDate()

        'Data do BL

        tstream = tstream + Data_BL()
        'Eventos
        '        If Eventos <> "" Then tstream.WriteLine (Eventos)
        'ActBookedDate

        If Trim(ActBookedDate) <> "" Then tstream = tstream + ActBookedDate()
        'EntryImmediateDeliveryReceivedDate

        If Trim(EntryImmediateDeliveryReceivedDate) <> "" Then tstream = tstream + EntryImmediateDeliveryReceivedDate()

        'ORDER DATE

        If Order_Date() <> "" Then tstream = tstream + Order_Date()

        'DEADLINE
        If Data_DeadLine() <> "" Then tstream = tstream + Data_DeadLine()

        'SolasVrfdGrMassCutDt
        tstream = tstream + DeadLine_VGM()

        'CarrierDocCutoffDate
        tstream = tstream + DeadLine_Draft()

        'Docs
        '   tstream.WriteLine (Doc)
        '
        'Eventos

        If Task() <> "" Then tstream = tstream + Task()
        'Eventos_Dow
        'If Dow_Status <> "" Then tstream.WriteLine (Dow_Status)
        'Data DI

        If Data_DI() <> "" Then tstream = tstream + Data_DI()
        'CustomsEntryPermitSubmissionDate

        If CustomsEntryPermitSubmissionDate() <> "" Then tstream = tstream + CustomsEntryPermitSubmissionDate()
        'GenericDates
        'tstream.WriteLine (GenericDate(RsProcesso!processo))
        'Pagamentos SDA

        tstream = tstream + Pagamentos(ProcessoDT.Rows(0)("processo").ToString(), "SDA")
        'Pagamentos Armazenagem

        tstream = tstream + Pagamentos(ProcessoDT.Rows(0)("processo").ToString(), "Armazenagem")

        'Data Certificado de Origem

        tstream = tstream + DataCertificadoDeOrigem(ProcessoDT.Rows(0)("processo").ToString())

        'LastModifiedByDate

        tstream = tstream + LastModifiedByDate()

        'Air Docs
        If (strLayout.Equals("Levis")) Then
            'Retirado, pois j� enviado a tag qdo eh atualizado no task: Chegada de Docs
            'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Then tstream = tstream + Doc_Aereo()
        Else

            If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Then tstream = tstream + Doc_Aereo()
        End If

        'Insercao

        tstream = tstream + Insercao()

        tstream = tstream + FileCreationDate()

        'NG BDPBillingInvoiceDateActual
        tstream = tstream + BDPBillingInvoiceDateActual()

        'NonConformance
        'Regra Inserida por Erbson 19/08/2015 - N�o utilizar par ao 301
        If (StrType.Equals("301") = False) Then
            If NC(ProcessoDT.Rows(0)("processo").ToString()) <> "" Then


                tstream = tstream + NC(ProcessoDT.Rows(0)("processo").ToString())

            End If
        End If
        ' CourierDocument
        'tstream.WriteLine (CourierDocument) - Removido em 26/01/2011 - Requisitado por Cathy (BdP us)
        'Amounts

        If StrType.Equals("ShippingInstruction") Then
            tstream = tstream + DocumentsSI()
        End If

        tstream = tstream + Amounts("BaseFreightBolAwbAmountPrepaid")

        tstream = tstream + Amounts("TotalFreightBolAwbPrepaidAmount")

        tstream = tstream + Amounts("BaseFreightDomesticInlandAmount")

        tstream = tstream + Amounts("DomesticInlandTotalFreightAmount")

        tstream = tstream + Amounts("ReportableValueAmount")

        tstream = tstream + Amounts("NumberOfTEUs")

        tstream = tstream + Amounts("TotalWeightKG")
        If strConsol = "Y" Then

            tstream = tstream + ConsolProfitShareBDPAmt()

            tstream = tstream + ConsolProfitShareAgentAmt()

            tstream = tstream + ConsolDeconsolCostAmt()

            tstream = tstream + ConsolDeconsolRevenueAmt()

            tstream = tstream + AgentProfitShareAmt()

            tstream = tstream + ConsolDeconsolCreditAmt()

            tstream = tstream + ConsolDeconsolNetMarginAmt()



        End If


        'Amounts para EA
        'If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2)) = "EA" Then
        If UCase(ProcessoDT.Rows(0)("processo").ToString().Substring(1, 1)) = "A" Then

            tstream = tstream + Amounts("ChargableRateAmount")

            tstream = tstream + Amounts("ChargeableWeight")

        End If


        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" And IsDBNull(ProcessoDT.Rows(0)("cd_plantaorigem")) = False Then

            If Location_Renamed("DomesticInland", ProcessoDT.Rows(0)("cd_plantaorigem").ToString()) <> "" Then tstream = tstream + Location_Renamed("DomesticInland", ProcessoDT.Rows(0)("cd_plantaorigem").ToString())
        Else

            'DestinationInland

            If IsDBNull(ProcessoDT.Rows(0)("dstFinal")) = False Then

                If Location_Renamed("DestinationInland", ProcessoDT.Rows(0)("dstFinal").ToString()) <> "" Then

                    tstream = tstream + Location_Renamed("DestinationInland", ProcessoDT.Rows(0)("dstFinal").ToString())

                End If
            End If
        End If

        tstream = tstream + PierTerminal()

        'CodesNames



        tstream = tstream + CodesNames("CargoDescription")

        tstream = tstream + CodesNames("SalesPerson")

        tstream = tstream + CodesNames("TypSvc")

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I" Then

            tstream = tstream + CodesNames("DestinationInlandCarrier")
        End If

        'BDPInvoices
        tstream = tstream + BDPInvoice(ProcessoDT.Rows(0)("processo").ToString())

        'Service Centers
        tstream = tstream + ServiceCenter()

        ' Header
        tstream = tstream + Fecha_Header()

        'aBRE DETALHES

        'prODUTO
        'tstream.WriteLine (Produto(RsProcesso!processo))

        'If Trim(Produto_Novo) <> "" Then

        '    tstream = tstream + Produto_Novo()

        If Trim(Produto_Novo_SB.ToString()) <> "" Then

            'tstream = tstream + Produto_Novo()
            tstream = tstream + Produto_Novo_SB.ToString()

            tstream = tstream + Footer()

            tstream = tstream + Footer_Net()
        Else

            tstream = tstream + Abre_Detalhe()

            tstream = tstream + Sem_Produto()
            'tstream.WriteLine (Duty)

            tstream = tstream + Fecha_Detalhe()

            tstream = tstream + Footer()

            tstream = tstream + Footer_Net()

        End If

        'Fecha Detalhes

        'Fecha Arquivo

        tstream = tstream.ToString().Replace("&", " AND ") + Fecha_Arquivo()

        Dim doc As XmlDocument = New XmlDocument()
        doc.Load(New StringReader(tstream.ToString()))
        'tstream.Close()
        Dim sqlCon As New cConexao()
        sqlCon.arqINI = strINI
        sqlCon.Conectar()

        If Directory.Exists("Saida\") = False Then
            Directory.CreateDirectory("Saida\")
        End If

        If strLayout.Equals("Levis") Then
            'doc.Load(My.Application.Info.DirectoryPath & "\" & StrUltimo)
            Dim strString As String = doc.InnerXml
            Dim RsCMD As New SqlCommand("spSmart_LEVIS_XML_Ins", sqlCon.cnn)
            RsCMD.CommandType = CommandType.StoredProcedure
            RsCMD.Parameters.Add("@Num_Proc", SqlDbType.VarChar, 16).Value = strProcesso
            RsCMD.Parameters.AddWithValue("@XML_DOC", strString)
            RsCMD.Parameters.Add("@Nome_Arquivo", SqlDbType.VarChar, 500).Value = StrUltimo
            RsCMD.Parameters.Add("@ISD_Number", SqlDbType.VarChar, 200).Value = strLevisISD
            RsCMD.ExecuteNonQuery()
        ElseIf StrType.Equals("ShippingInstruction") Then
            Dim OUT As Object
            OUT = Arquivo.OpenTextFile(My.Application.Info.DirectoryPath & "\Saida\" & StrUltimo, Scripting.IOMode.ForWriting, True)
            OUT.Write(tstream.ToString())
            OUT.Close()

            Dim strString As String = doc.InnerXml
            Dim RsCMD As New SqlCommand("spATL_GTNEXUS_XML_Ins", sqlCon.cnn)
            RsCMD.CommandType = CommandType.StoredProcedure
            RsCMD.Parameters.Add("@ID_Smart", SqlDbType.BigInt).Value = DBNull.Value
            RsCMD.Parameters.Add("@Id_GTNexus", SqlDbType.BigInt).Value = strLevisISD
            RsCMD.Parameters.Add("@Num_Proc", SqlDbType.VarChar, 16).Value = strProcesso
            RsCMD.Parameters.Add("@Type", SqlDbType.VarChar, 2).Value = "SI"
            RsCMD.Parameters.AddWithValue("@XML_DOC", strString)
            RsCMD.Parameters.Add("@Nome_Arquivo", SqlDbType.VarChar, 500).Value = StrUltimo
            RsCMD.Parameters.Add("@Dt_Ins", SqlDbType.DateTime).Value = DBNull.Value
            RsCMD.Parameters.Add("@Dt_Envio", SqlDbType.DateTime).Value = DBNull.Value
            RsCMD.ExecuteNonQuery()
        Else
            If StrType.Equals("301") Then
                'Arquivo.CreateTextFile(My.Application.Info.DirectoryPath & "\" & StrUltimo)
                Dim OUT As Object
                OUT = Arquivo.OpenTextFile(My.Application.Info.DirectoryPath & "\Saida\" & StrUltimo, Scripting.IOMode.ForWriting, True)
                'OUT.WriteLine(tstream.ToString())
                OUT.Write(tstream.ToString())
                OUT.Close()
                'doc.Save(My.Application.Info.DirectoryPath & "\" & StrUltimo)
            Else
                Dim strString As String = doc.InnerXml
                Dim RsCMD As New SqlCommand("spSmartXMLODS_Ins", sqlCon.cnn)
                RsCMD.CommandType = CommandType.StoredProcedure
                RsCMD.Parameters.Add("@Num_Proc", SqlDbType.VarChar, 16).Value = strProcesso
                RsCMD.Parameters.AddWithValue("@XML_DOC", strString)
                RsCMD.Parameters.Add("@Nome_Arquivo", SqlDbType.VarChar, 500).Value = StrUltimo
                RsCMD.ExecuteNonQuery()

                Dim OUT As Object
                OUT = Arquivo.OpenTextFile(My.Application.Info.DirectoryPath & "\Saida\" & StrUltimo, Scripting.IOMode.ForWriting, True)
                OUT.Write(tstream.ToString())
                OUT.Close()
            End If
        End If

        'escrever.Close()
        'escrever = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\Log\XML" & CStr(Month(Now)) & ".log", Scripting.IOMode.ForAppending, True)

        GravaLOG_Historico(ProcessoDT.Rows(0)("processo").ToString() + vbTab + StrUltimo + vbTab + CStr(Now))
        'Console.WriteLine(ProcessoDT.Rows(0)("processo").ToString() + vbTab + StrUltimo + vbTab + CStr(Now))

        'ReconcLog = ArqLog.OpenTextFile(My.Application.Info.DirectoryPath & "\RECONCILE_" & StrCdPais & "_" & VB6.Format(Now, "YYYYMMDD") & ".txt", Scripting.IOMode.ForAppending, True)

        'ReconcLog.WriteLine(StrUltimo)
        'ReconcLog.WriteLine()
        'ReconcLog.Close()
        'escrever.Close()

        'RsProcesso = Nothing
        ' RsProcesso.Close()

        'Arquivo.CopyFile(My.Application.Info.DirectoryPath & "\" & StrUltimo, My.Application.Info.DirectoryPath & "\Saida\" & StrUltimo)
        'If Arquivo.FileExists(My.Application.Info.DirectoryPath & "\" & StrUltimo) Then
        'tstream.Close()
        'Arquivo.DeleteFile(My.Application.Info.DirectoryPath & "\" & StrUltimo)
        'End If

    End Sub


    Private Function Pagamentos(ByRef strProcesso As String, ByRef strTaxa As String) As String

        Dim StrTipoPgto As String
        Dim ltempDT As New Data.DataTable


        StrSql = "spINTSmartPagamentos_Sel '" & strProcesso & "','%" & strTaxa & "%'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)



        Pagamentos = ""

        If strTaxa = "Armazenagem" Then

            StrTipoPgto = "WarehousePayDt"
        Else
            StrTipoPgto = "SDAPayDt"

        End If



        If ltempDT.Rows.Count > 0 Then
            Pagamentos = Pagamentos & "<Status>"
            Pagamentos = Pagamentos & " <StatusType type='" & StrTipoPgto & "'></StatusType>"

            If IsDBNull(ltempDT.Rows(0)("Data")) = True Then
                Pagamentos = Pagamentos & "<StatusDate></StatusDate>"
            Else
                Pagamentos = Pagamentos & "<StatusDate>" & VB6.Format(ltempDT.Rows(0)("Data").ToString(), "yyyymmdd") & "</StatusDate>"
            End If
            Pagamentos = Pagamentos & "</Status>"
        End If


    End Function

    Private Function License(ByRef strProcesso As String) As String
        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IA"
                Select Case StrPais
                    Case "Brasil"
                        ' Id_DC = "23"
                        StrSql = "select numero_po_hia LI,data_po_hia LI_Data from PO_Hia with(nolock) where id_dc='23' and num_proc_hia='" & strProcesso & "' AND NUMERO_PO_HIA LIKE '%/%'"
                    Case "Argentina"
                        '    Id_DC = "78"
                        StrSql = "select numero_po_hia LI,data_po_hia LI_Data from PO_Hia with(nolock) where id_dc='78' and num_proc_hia='" & strProcesso & "' "
                End Select
            Case "IO"
                Select Case StrPais
                    Case "Brasil"
                        ' Id_DC = "23"
                        StrSql = "select numero_po_hIO LI,data_po_hIO LI_Data from PO_HIO with(nolock) where id_dc='23' and num_proc_hIO='" & strProcesso & "' AND NUMERO_PO_HIO LIKE '%/%'"
                    Case "Argentina"
                        'Id_DC = "78"
                        StrSql = "select numero_po_hIO LI,data_po_hIO LI_Data from PO_HIO with(nolock) where id_dc='78' and num_proc_hIO='" & strProcesso & "' "
                End Select
            Case "IM"
                Select Case StrPais
                    Case "Brasil"
                        ' Id_DC = "23"
                        StrSql = "select numero_po_hIm LI,data_po_hIm LI_Data from PO_HIm with(nolock) where id_dc='23' and num_proc_hIm='" & strProcesso & "' AND NUMERO_PO_HIM LIKE '%/%'"
                    Case "Argentina"
                        ' Id_DC = "78"
                        StrSql = "select numero_po_hIm LI,data_po_hIm LI_Data from PO_HIm with(nolock) where id_dc='78' and num_proc_hIm='" & strProcesso & "'"
                End Select
            Case Else
                Exit Function
        End Select
        If StrPais <> "Chile" Then


            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then
                License = "<License>" & vbCrLf

                License = License & "<IssueDate>" & IIf(IsDBNull(ltempDT.Rows(0)("li_data")) = True, "", VB6.Format(ltempDT.Rows(0)("li_data").ToString(), "yyyymmdd")) & "</IssueDate>" & vbCrLf

                If IsDBNull(ltempDT.Rows(0)("li_data")) = True Then
                    License = License & "<ExpirationDate></ExpirationDate>" & vbCrLf
                Else
                    License = License & "<ExpirationDate>" & VB6.Format(CDate(ltempDT.Rows(0)("li_data").ToString()).AddDays(60), "yyyymmdd") & "</ExpirationDate>" & vbCrLf
                End If



                License = License & "<LicenceNumber>" & IIf(IsDBNull(ltempDT.Rows(0)("LI")) = True, "", ltempDT.Rows(0)("LI").ToString()) & "</LicenceNumber>" & vbCrLf
                License = License & "<StateDepartmentExemption>" & "PF" & "</StateDepartmentExemption>" & vbCrLf
                License = License & "</License>"

            End If
        End If




    End Function

    Private Function LicenseProduto(ByRef strProcesso As String) As String


        Dim ltempDT As New Data.DataTable
        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IA"
                StrSql = "select numero_po_hia LI,data_po_hia LI_Data from PO_Hia with(nolock) where id_dc=23 and num_proc_hia='" & strProcesso & "' AND NUMERO_PO_HIA LIKE '%/%'"
            Case "IO"
                StrSql = "select numero_po_hIO LI,data_po_hIO LI_Data from PO_HIO with(nolock) where id_dc=23 and num_proc_hIO='" & strProcesso & "' AND NUMERO_PO_HIO LIKE '%/%'"
            Case "IM"
                StrSql = "select numero_po_hIm LI,data_po_hIm LI_Data from PO_HIm with(nolock) where id_dc=23 and num_proc_hIm='" & strProcesso & "' AND NUMERO_PO_HIM LIKE '%/%'"
            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            LicenseProduto = "<License>" & vbCrLf

            LicenseProduto = LicenseProduto & "<LicenceNumber>" & IIf(IsDBNull(ltempDT.Rows(0)("LI")) = True, "", ltempDT.Rows(0)("LI").ToString()) & "</LicenceNumber>" & vbCrLf
            LicenseProduto = LicenseProduto & "<AmendQuantity>" & "</AmendQuantity>" & vbCrLf
            LicenseProduto = LicenseProduto & "<AmendUnit>" & "</AmendUnit>" & vbCrLf
            LicenseProduto = LicenseProduto & vbCrLf
            LicenseProduto = LicenseProduto & "</License>"

        End If



    End Function

    Private Function BDPInvoice(ByRef strProcesso As String) As String



        Dim StrSaida As String
        Dim StrCabecalho As String
        Dim StrDetalhe As String
        Dim strMoeda As String
        Dim decTotal As Decimal
        Dim strFatStatus As String
        Dim ltempDT As New Data.DataTable
        Dim lTaxaDT As New Data.DataTable

        If StrPais = "Argentina" Then
            StrSql = "select Top 1 F.ID_Fat fatcod from Fatura_Arg F join Fatura_ARG_Det FD on f.ID_Fat=fd.ID_Fat where F.Status<>'D' AND left(Num_Proc,16)='" & strProcesso & "'"

        Else
            StrSql = "select fatcod from fatura with(nolock) where left(fatcod,16)='" & strProcesso & "'"
        End If
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        StrSaida = ""


        For Each lTempDR As Data.DataRow In ltempDT.Rows
            'Erbson
            'RsTaxa = Nothing

            StrSql = "spSmartBDPInvoice_Sel '" + lTempDR("fatcod").ToString() + "'"

            lTaxaDT = sqlCnn.BuscaInformacoes(StrSql)
            If lTaxaDT.Rows.Count > 0 Then

                StrCabecalho = "<BDPInvoice>"
                If strConsol = "Y" Then
                    StrCabecalho = StrCabecalho & "<InvoiceNumber>" + ProcessoDT.Rows(0)("num_master").ToString() + "</InvoiceNumber>"
                Else
                    StrCabecalho = StrCabecalho & "<InvoiceNumber>" + lTaxaDT.Rows(0)("invoicenumber").ToString() + "</InvoiceNumber>"
                End If
                StrCabecalho = StrCabecalho & "<InvoiceDate>" & VB6.Format(lTaxaDT.Rows(0)("INVOICEDATE").ToString(), "yyyymmdd") & "</InvoiceDate>"
                strMoeda = lTaxaDT.Rows(0)("Cd_Moeda").ToString()
                strFatStatus = lTaxaDT.Rows(0)("fatstatus").ToString()
                StrDetalhe = ""
                decTotal = 0

                For Each lTaxaDR As DataRow In lTaxaDT.Rows


                    StrDetalhe = StrDetalhe & "<Charges>"
                    StrDetalhe = StrDetalhe & "<Type>" & "N" & "</Type>"
                    StrDetalhe = StrDetalhe & "<Code>" & Upper_Case(lTaxaDR.Item("CHARGECODE").ToString()) & "</Code>"
                    StrDetalhe = StrDetalhe & "<Description>" & Upper_Case(lTaxaDR.Item("CHARGE").ToString()) & "</Description>"
                    StrDetalhe = StrDetalhe & "<Amount>" & Replace(VB6.Format(CStr(lTaxaDR.Item("vlr_org").ToString()), "0.00"), ",", ".") & "</Amount>"
                    StrDetalhe = StrDetalhe & "<Currency>" + lTaxaDR.Item("Cd_Moeda").ToString() + "</Currency>"
                    StrDetalhe = StrDetalhe & "<VendorNumber>" + lTaxaDR.Item("Cd_Vendor").ToString() + "</VendorNumber>"
                    StrDetalhe = StrDetalhe & "<VendorName>" & Upper_Case(lTaxaDR.Item("Vendor").ToString()) & "</VendorName>"
                    If VB.Left(UCase(strProcesso), 1) = "I" Then
                        StrDetalhe = StrDetalhe & "<PrepaidAmount>" & "0.00" & "</PrepaidAmount>"
                        StrDetalhe = StrDetalhe & "<CollectAmount>" & Replace(VB6.Format(CStr(lTaxaDR.Item("vlr_org").ToString()), "0.00"), ",", ".") & "</CollectAmount>"
                    Else
                        StrDetalhe = StrDetalhe & "<PrepaidAmount>" & Replace(VB6.Format(CStr(lTaxaDR.Item("vlr_org").ToString()), "0.00"), ",", ".") & "</PrepaidAmount>"
                        StrDetalhe = StrDetalhe & "<CollectAmount>" & "0.00" & "</CollectAmount>"
                    End If
                    decTotal = decTotal + lTaxaDR.Item("vlr_org")
                    StrDetalhe = StrDetalhe & "</Charges>"



                Next
                StrCabecalho = StrCabecalho & "<InvoiceTotal>" & Replace(VB6.Format(CStr(decTotal), "0.00"), ",", ".") & "</InvoiceTotal>"
                StrCabecalho = StrCabecalho & StrDetalhe
                StrCabecalho = StrCabecalho & "<VoidedFlagYN>" & strFatStatus & "</VoidedFlagYN>"
                StrCabecalho = StrCabecalho & "<InvoiceTotalCurrency>" & UCase(strMoeda) & "</InvoiceTotalCurrency>"
                StrCabecalho = StrCabecalho & "</BDPInvoice>"
                StrSaida = StrSaida & StrCabecalho


            End If


        Next


        BDPInvoice = StrSaida





    End Function

    Private Function ServiceCenter() As String
        'THV

        ServiceCenter = ""
        Exit Function
        ServiceCenter = "<ServiceCenter>"
        ServiceCenter = ServiceCenter & "<Sequence>1" & "</Sequence>"
        ServiceCenter = ServiceCenter & "<ToFrom>ToYork</ToFrom>"
        ServiceCenter = ServiceCenter & "<Code>" & "USTHV" & "</Code>"
        ServiceCenter = ServiceCenter & "<Name>" & "UNITED STATES, YORK, PA" & "</Name>"
        ServiceCenter = ServiceCenter & "<EntryBy>" & "AOLIVEIRA" & "</EntryBy>"
        ServiceCenter = ServiceCenter & "<ActionDate>" & VB6.Format(Now, "yyyymmdd") & "</ActionDate>"
        ServiceCenter = ServiceCenter & "<ActionTime>" & VB6.Format(Now, "hhmmss") & "</ActionTime>"
        ServiceCenter = ServiceCenter & "</ServiceCenter>"



    End Function


    'Private Function CodesNames(ByRef strTipo As String) As String


    '    Dim strDados As String
    '    Dim strCode As String
    '    Dim ltempDT As New Data.DataTable

    '    strDados = ""
    '    strCode = ""
    '    Select Case UCase(strTipo)
    '        Case UCase("SalesPerson")
    '            StrSql = "spINTSmartVendedor_Sel '" & ProcessoDT.Rows(0)("processo").ToString() & "'"

    '            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '            If ltempDT.Rows.Count > 0 Then

    '                strDados = IIf(IsDBNull(ltempDT.Rows(0)("nome_usuario")) = True, "", ltempDT.Rows(0)("nome_usuario").ToString())
    '            End If

    '        Case UCase("CargoDescription")
    '            strDados = Upper_Case(Nature_Goods_Samples)
    '        Case UCase("DestinationInlandCarrier")
    '            'RsTemp = Nothing

    '            StrSql = "spINTSmartBuscaTransportadora_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"

    '            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '            If ltempDT.Rows.Count > 0 Then

    '                If IsDBNull(ltempDT.Rows(0)("nome_raz_soc")) = False Then
    '                    strDados = Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString())
    '                    strCode = ltempDT.Rows(0)("Cd_Vendor").ToString()
    '                End If
    '            End If
    '        Case UCase("SapTrnsprtPoint")

    '            StrSql = "spINTSmartBuscaSapTrnsprtPoint_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"

    '            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '            If ltempDT.Rows.Count > 0 Then
    '                If IsDBNull(ltempDT.Rows(0)("SapTrnsprtPoint")) = False And ltempDT.Rows(0)("SapTrnsprtPoint").ToString().Length > 0 Then
    '                    strDados = Upper_Case(ltempDT.Rows(0)("SapTrnsprtPoint").ToString())
    '                End If
    '            End If
    '    End Select


    '    CodesNames = ""
    '    CodesNames = "<CodesNames>" & vbCrLf
    '    CodesNames = CodesNames & "<CodesNamesType>" & strTipo & "</CodesNamesType>"
    '    CodesNames = CodesNames & "<CodesNamesName>"
    '    CodesNames = CodesNames & "<![CDATA[" & (strDados) & "]]>"

    '    CodesNames = CodesNames & "</CodesNamesName>"
    '    CodesNames = CodesNames & "<CodesNamesCode>" & strCode & "</CodesNamesCode>"
    '    CodesNames = CodesNames & "</CodesNames>"

    '    CodesNames = Replace(CodesNames, Chr(160), " ")
    '    CodesNames = Replace(CodesNames, Chr(13), " ")
    '    CodesNames = Replace(CodesNames, Chr(10), " ")


    'End Function

    Private Function NC(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable
        Dim IntI As Short

        StrSql = "select cd_nc, descricao_nc, hsgdata DAta from hist_geral with(nolock) " & " Join tipo_nc_cliente TNC with(nolock) on TNC.cd_nc = ID_NC Collate Latin1_General_CI_AI " & " where id_nc is not null and hsgprocesso='" & strProcesso & "'"
        NC = ""

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        IntI = 1
        For Each lTempDR As DataRow In ltempDT.Rows
            '2020-11-16, Anderson: Removed <Type>  as requested"
            NC = NC & "<NonConformance>" & vbCrLf
            NC = NC & "<ReasonCode>" + lTempDR.Item("cd_nc").ToString() + "</ReasonCode>" + vbCrLf
            NC = NC & "<ReasonDesc>" + lTempDR.Item("descricao_nc").ToString() + "</ReasonDesc>" + vbCrLf
            NC = NC & "<Date>" & VB6.Format(lTempDR.Item("Data").ToString(), "yyyymmdd") & "</Date>" & vbCrLf
            NC = NC & "</NonConformance>"
            IntI = IntI + 1
        Next

    End Function

    Private Function DeliveryTransportation(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable
        DeliveryTransportation = ""

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select nome_raz_soc from llp_imp_mar with(nolock) join pessoa pp with(nolock) on pp.cd_pes=Cd_Transportadora where num_proc_lim='" & strProcesso & "'"
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            DeliveryTransportation = "<References type='DeliveringCarrier'>" & vbCrLf
            DeliveryTransportation = DeliveryTransportation & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString()) & "</ReferenceNumber>" & vbCrLf
            DeliveryTransportation = DeliveryTransportation & "</References>"
        End If

    End Function

    Private Function DeliveryTranPartner(ByRef strProcesso As String) As String


        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select cd_transportadora from llp_imp_mar with(nolock) where num_proc_lim='" & strProcesso & "'"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        DeliveryTranPartner = ""

        If ltempDT.Rows.Count > 0 Then

            StrSql = "spintPessoa_Sel '" & ltempDT.Rows(0)("cd_transportadora").ToString() & "'"
            ltempDT = New Data.DataTable()
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            If ltempDT.Rows.Count > 0 Then
                DeliveryTranPartner = "<Parties type=""DeliveringCarrier"">" & vbCrLf
                DeliveryTranPartner = DeliveryTranPartner & "<Party-Name>" & Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString()) & "</Party-Name>" & vbCrLf

                DeliveryTranPartner = DeliveryTranPartner & "<Party-Address>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("endereco")) = True, "", ltempDT.Rows(0)("endereco").ToString())) & "</Party-Address>" & vbCrLf

                DeliveryTranPartner = DeliveryTranPartner & "<Party-City>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cidade")) = True, "", ltempDT.Rows(0)("cidade").ToString())) & "</Party-City>" & vbCrLf

                DeliveryTranPartner = DeliveryTranPartner & "<Party-State-Prov>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("uf")) = True, "", ltempDT.Rows(0)("uf").ToString())) & "</Party-State-Prov>" & vbCrLf

                DeliveryTranPartner = DeliveryTranPartner & "<Party-PostalCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cep")) = True, "", ltempDT.Rows(0)("cep").ToString())) & "</Party-PostalCode>" & vbCrLf
                DeliveryTranPartner = DeliveryTranPartner & "<Party-Contacts Action='' type=""InlandContact"">" & vbCrLf

                DeliveryTranPartner = DeliveryTranPartner & "<Contact-Name>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("contato")) = True, "", ltempDT.Rows(0)("contato").ToString())) & "</Contact-Name>" & vbCrLf

                DeliveryTranPartner = CStr(CDbl(DeliveryTranPartner & "<Contact-CommunicationAddress type=""Email"">") + IIf(IsDBNull(ltempDT.Rows(0)("compl_fone")) = True, "", " ") + CDbl("</Contact-CommunicationAddress>") + CDbl(vbCrLf))

                DeliveryTranPartner = CStr(CDbl(DeliveryTranPartner & "<Contact-CommunicationAddress type=""Telephone"">") + IIf(IsDBNull(ltempDT.Rows(0)("compl_fone")) = True, "", ltempDT.Rows(0)("TELEFONE").ToString()) + CDbl("</Contact-CommunicationAddress>") + CDbl(vbCrLf))
                DeliveryTranPartner = DeliveryTranPartner & "</Party-Contacts>"

                DeliveryTranPartner = DeliveryTranPartner & "</Parties>"
            End If

        End If


    End Function

    Private Function Busca_NCM(ByRef strProcesso As String) As String


        Dim ltempDT As New Data.DataTable

        StrSql = "select Left(NCM,8) NCM from proc_ncm P with(nolock) " & " Join NCM with(nolock) on NCM.ID_NCM=P.ID_NCM " & " Where num_proc='" & strProcesso & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            Busca_NCM = ltempDT.Rows(0)("ncm").ToString()
        Else
            ltempDT = New DataTable()
            Select Case StrPais
                Case "Brasil"
                    Busca_NCM = ""
                Case "Argentina"
                    StrSql = "select ncm NCM from ncm_sim_arg with(nolock) " & " Where num_proc='" & StrPROC & "'"
                    ltempDT = sqlCnn.BuscaInformacoes(StrSql)

                    If ltempDT.Rows.Count > 0 Then
                        Busca_NCM = ltempDT.Rows(0)("ncm").ToString()
                    End If
                Case "Chile"
                    Busca_NCM = ""

            End Select
        End If



    End Function

    Private Function Sales_Diferentes() As String


        Dim ltempDT As New Data.DataTable
        Sales_Diferentes = ""

        StrSql = "select count(distinct(num_pedido)) Ordem from pedido_ship PS with(nolock)" & " Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido" & " Where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            If ltempDT.Rows(0)("ordem").ToString() <= 1 Then
                Sales_Diferentes = ""
                Exit Function
            End If
        Else
            Exit Function
        End If


        StrSql = "select distinct(num_pedido) Ordem from pedido_ship PS with(nolock) " & " Join Pedido PD  with(nolock) on PD.cd_pedido=PS.cd_pedido" & " Where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = New DataTable()
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Sales_Diferentes = ""
        For Each lTempDR As DataRow In ltempDT.Rows
            If Sales_Diferentes.Equals("") Then
                Sales_Diferentes = lTempDR.Item("ordem").ToString()
            Else
                Sales_Diferentes = Sales_Diferentes & " / " + lTempDR.Item("ordem").ToString()
            End If
        Next

    End Function


    Private Function Dow_Status() As String


        Dim ltempDT As New Data.DataTable
        StrSql = "spINTStatusDow_Int '" & ProcessoDT.Rows(0)("processo").ToString() & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        If ltempDT.Rows.Count > 0 Then
            Dow_Status = "<Status>" & vbCrLf
            Dow_Status = Dow_Status & "<StatusType type='RequestedDeliveryDate' />" & vbCrLf
            Dow_Status = Dow_Status & "<StatusDate>" & (VB6.Format(CDate(ProcessoDT.Rows(0)("dl_chegada").ToString()), "yyyymmdd")) & "</StatusDate>" & vbCrLf
            Dow_Status = Dow_Status & "</Status>"
            For Each lTempDR As DataRow In ltempDT.Rows
                Dow_Status = Dow_Status & vbCrLf
                Dow_Status = Dow_Status & "<Status>" & vbCrLf
                Dow_Status = Dow_Status & "<StatusType type='" + lTempDR.Item("BDPSmart_Descr").ToString() + "'/>" + vbCrLf
                Dow_Status = Dow_Status & "<StatusDate>" & VB6.Format(VB6.Format(CDate(lTempDR.Item("Data").ToString()), "yyyymmdd")) & "</StatusDate>" & vbCrLf
                Dow_Status = Dow_Status & "</Status>"
            Next

        End If

    End Function

    Private Function CartaCredito(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "SELECT numero_po_him  Numero FROM PO_HIM with(nolock) WHERE NUM_PROC_him='" & strProcesso & "' AND ID_DC=71"
            Case "EM"
                StrSql = "SELECT numero_po_hem  Numero FROM PO_HEM with(nolock)  WHERE NUM_PROC_hem='" & strProcesso & "' AND ID_DC=71"
            Case "EA"
                StrSql = "SELECT numero_po_hea  Numero FROM PO_HEA with(nolock)  WHERE NUM_PROC_hea='" & strProcesso & "' AND ID_DC=71"
            Case "IA"
                StrSql = "SELECT numero_po_hia  Numero FROM PO_HiA with(nolock)  WHERE NUM_PROC_hia='" & strProcesso & "' AND ID_DC=71"
            Case "IO"
                StrSql = "SELECT numero_po_hio Numero FROM PO_HiO with(nolock)  WHERE NUM_PROC_hio='" & strProcesso & "' AND ID_DC=71"
            Case "EO"
                StrSql = "SELECT numero_po_heo Numero FROM PO_HEO with(nolock)  WHERE NUM_PROC_hEo='" & strProcesso & "' AND ID_DC=71"

        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            CartaCredito = "<LetterofCredit>" & vbCrLf
            CartaCredito = CartaCredito & "<RequiredYN>N</RequiredYN>" & vbCrLf
            CartaCredito = CartaCredito & "<IssueNumber></IssueNumber>" & vbCrLf
            CartaCredito = CartaCredito & "</LetterofCredit>"
        Else
            CartaCredito = "<LetterofCredit>" & vbCrLf
            CartaCredito = CartaCredito & "<RequiredYN>Y</RequiredYN>" & vbCrLf
            CartaCredito = CartaCredito & "<IssueNumber>" + ltempDT.Rows(0)("numero").ToString() + "</IssueNumber>" + vbCrLf
            CartaCredito = CartaCredito & "</LetterofCredit>"
        End If


    End Function

    Private Function Location_Renamed(ByRef strTipo As String, ByRef strLocal As String) As String

        Location_Renamed = ""

        Location_Renamed = "<Locations>" & vbCrLf
        Location_Renamed = Location_Renamed & "<LocationType>" & strTipo & "</LocationType>"
        Location_Renamed = Location_Renamed & "<LocationName>" & Nome_Local(strLocal) & "</LocationName>" & vbCrLf
        Location_Renamed = Location_Renamed & "<LocationUnlocCode>" & BiTri(strLocal) & "</LocationUnlocCode>" & vbCrLf
        Location_Renamed = Location_Renamed & "<LocationCountryCode>" & VB.Left(BiTri(strLocal), 2) & "</LocationCountryCode>" & vbCrLf
        Location_Renamed = Location_Renamed & "<LocationCountryName>" & Nome_Local(strLocal) & "</LocationCountryName>"
        Location_Renamed = Location_Renamed & "<LocationCode></LocationCode>" & vbCrLf
        Location_Renamed = Location_Renamed & "</Locations>"

    End Function

    Private Function PierTerminal() As String


        Dim ltempDT As New Data.DataTable
        StrSql = "spIntSmartTerminal_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"


        PierTerminal = ""

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            PierTerminal = "<Locations>" & vbCrLf
            PierTerminal = PierTerminal & "<LocationType>" & "PierTerminal" & "</LocationType>"
            PierTerminal = PierTerminal & "<LocationName>" & Upper_Case(ltempDT.Rows(0)("nome_Terminal").ToString()) & "</LocationName>" & vbCrLf
            PierTerminal = PierTerminal & "<LocationUnlocCode>" & "</LocationUnlocCode>" & vbCrLf
            PierTerminal = PierTerminal & "<LocationCountryCode>" & "</LocationCountryCode>" & vbCrLf
            PierTerminal = PierTerminal & "<LocationCountryName>" & "</LocationCountryName>"
            PierTerminal = PierTerminal & "<LocationCode></LocationCode>" & vbCrLf
            PierTerminal = PierTerminal & "</Locations>"
        End If

    End Function



    Private Function Amounts(ByRef strTipo As String) As String

        Dim strValor As String
        Dim ltempDT As New Data.DataTable

        If UCase("BaseFreightBolAwbAmountPrepaid") = UCase(strTipo) Then
            strTipo = "BaseFreightBolAwbAmountPrepaid"
            strTipo = Replace(strTipo, " ", "")
        End If

        strValor = "0.00"

        Select Case UCase(strTipo)
            Case UCase("BaseFreightBolAwbAmountPrepaid"), UCase("TotalFreightBolAwbPrepaidAmount")
                If UCase(ProcessoDT.Rows(0)("tp_frete").ToString()) = "P" Then
                    strValor = Replace(VB6.Format(ProcessoDT.Rows(0)("vlr_frete").ToString(), "0.00"), ",", ".")
                Else
                    strValor = "0.00"
                End If
            Case UCase("ReportableValueAmount"), UCase("ReportableValueAmount")

                strValor = Replace(VB6.Format(glbfltTotalInvoice, "0.00"), ",", ".")
            Case UCase("NumberOfTEUs")
                StrSql = "select [dbo].[fBusca_TEUS]('" + ProcessoDT.Rows(0)("processo").ToString() + "') Saida"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strValor = IIf(IsDBNull(ltempDT.Rows(0)("saida")) = True, "0.00", ltempDT.Rows(0)("saida").ToString())
                Else
                    strValor = "0.00"
                End If

            Case UCase("TotalWeightKG")

                strValor = IIf(IsDBNull(ProcessoDT.Rows(0)("Peso_Bruto")) = True, "0.00", ProcessoDT.Rows(0)("Peso_Bruto").ToString())
            Case UCase("ChargeableWeight")
                If UCase(ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2)) = "EA" Then
                    StrSql = "select Peso_Cubado_lea Peso_Cubado from llp_exp_aer with(nolock) where num_proc_lea='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                Else
                    StrSql = "select Peso_Cubado_lia Peso_Cubado from llp_imp_aer with(nolock) where num_proc_lia='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                End If

                ltempDT = New DataTable()
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then
                    strValor = IIf(IsDBNull(ltempDT.Rows(0)("PESO_CUBADO")) = True, "0.00", ltempDT.Rows(0)("PESO_CUBADO").ToString())
                End If
            Case UCase("ChargableRateAmount")
                StrSql = "select selling_rates_lea Tarifa,Peso_Cubado_lea Peso_Cubador from llp_exp_aer with(nolock) where num_proc_lea='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = New DataTable()
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strValor = IIf(IsDBNull(ltempDT.Rows(0)("TARIFA")) = True, "0.00", ltempDT.Rows(0)("TARIFA").ToString())
                End If



        End Select

        '    strValor = Format(CCur(strValor), "0.00")
        strValor = Replace(strValor, ",", ".")
        'estava removendo o valor 49 do numero
        'strValor = Replace(strValor, CStr(Asc(CStr(160))), "")
        strValor = Replace(strValor, Chr(160), "")

        'BaseFreightBolAwbAmountPrepaid =Vlr_Frete - tp_frete
        'TotalFreightBolAwbPrepaidAmount =Vlr_Frete - tp_frete
        'BaseFreightDomesticInlandAmount
        'DomesticInlandTotalFreightAmount
        'ReportableValueAmount
        'NumberOfTEUs




        Amounts = ""

        Amounts = "<Amounts>"
        Amounts = Amounts & "<AmountType>"
        Amounts = Amounts & "<![CDATA[" & Replace(Trim(strTipo), vbCrLf, "") & "]]>"
        Amounts = Amounts & "</AmountType>"
        Amounts = Amounts & "<AmountValue>"
        Amounts = Amounts & "<![CDATA[" & Trim(strValor) & "]]>"
        Amounts = Amounts & "</AmountValue>"
        Amounts = Amounts & "<AmountUnit>"
        Amounts = Amounts & "<![CDATA[" & "" & "]]>"
        Amounts = Amounts & "</AmountUnit>"
        If UCase(strTipo) = UCase("ReportableValueAmount") Or UCase(strTipo) = UCase("BaseFreightBolAwbAmountPrepaid") Or UCase(strTipo) = UCase("TotalFreightBolAwbPrepaidAmount") Then
            Amounts = Amounts & "<AmountCurrency>"
            Amounts = Amounts & "<![CDATA[USD]]>"
            Amounts = Amounts & "</AmountCurrency>"
        End If
        Amounts = Amounts & "<AmountCode>"
        Amounts = Amounts & "<![CDATA[" & "" & "]]>"
        Amounts = Amounts & "</AmountCode>"
        If UCase(strTipo) <> UCase("ReportableValueAmount") And UCase(strTipo) <> UCase("BaseFreightBolAwbAmountPrepaid") And UCase(strTipo) <> UCase("NumberOfTEUs") Then
            Amounts = Amounts & "<AmountIndicator>"
            Amounts = Amounts & "<![CDATA[" & "KG" & "]]>"
            Amounts = Amounts & "</AmountIndicator>"
        End If
        Amounts = Amounts & "</Amounts>"

        Amounts = Replace(Amounts, Chr(10), "")
        Amounts = Replace(Amounts, Chr(13), "")
        Amounts = Replace(Amounts, Chr(160), "")

    End Function

    Private Function ConsolProfitShareBDPAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select cd_tp_moeda,sum(vlr_org_hia) Valor from vwcta_Cte where num_proc_hia in (select num_proc from vwcliente where master='" + ProcessoDT.Rows(0)("num_master").ToString() + "') and dc_hia='C' and cd_tp_Tx='PBD' group by cd_tp_moeda "

        If ltempDT.Rows.Count > 0 Then
            ConsolProfitShareBDPAmt = "<Amounts>"
            ConsolProfitShareBDPAmt = ConsolProfitShareBDPAmt & "<AmountType>" & "ConsolProfitShareBDPAmt" & "</AmountType>"
            ConsolProfitShareBDPAmt = ConsolProfitShareBDPAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            ConsolProfitShareBDPAmt = ConsolProfitShareBDPAmt & "<AmountUnit>" & "</AmountUnit>"
            ConsolProfitShareBDPAmt = ConsolProfitShareBDPAmt & "<AmountCurrency>" + ltempDT.Rows(0)("cd_Tp_moeda").ToString() + "</AmountCurrency>"
            ConsolProfitShareBDPAmt = ConsolProfitShareBDPAmt & "<AmountCode>" & "</AmountCode>"
            ConsolProfitShareBDPAmt = ConsolProfitShareBDPAmt & "</Amounts>"
        End If




    End Function

    Private Function ConsolProfitShareAgentAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select cd_tp_moeda,sum(vlr_org_hia) Valor from vwcta_Cte where num_proc_hia in (select num_proc from vwcliente where master='" + ProcessoDT.Rows(0)("num_master").ToString() + "') and dc_hia='C' and cd_tp_Tx='PSA' group by cd_tp_moeda "


        If ltempDT.Rows.Count > 0 Then
            ConsolProfitShareAgentAmt = "<Amounts>"
            ConsolProfitShareAgentAmt = ConsolProfitShareAgentAmt & "<AmountType>" & "ConsolProfitShareAgentAmt" & "</AmountType>"
            ConsolProfitShareAgentAmt = ConsolProfitShareAgentAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            ConsolProfitShareAgentAmt = ConsolProfitShareAgentAmt & "<AmountUnit>" & "</AmountUnit>"
            ConsolProfitShareAgentAmt = ConsolProfitShareAgentAmt & "<AmountCurrency>" + ltempDT.Rows(0)("cd_Tp_moeda").ToString() + "</AmountCurrency>"
            ConsolProfitShareAgentAmt = ConsolProfitShareAgentAmt & "<AmountCode>" & "</AmountCode>"
            ConsolProfitShareAgentAmt = ConsolProfitShareAgentAmt & "</Amounts>"
        End If




    End Function

    Private Function AgentProfitShareAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select cd_tp_moeda,sum(vlr_org_hia) Valor from vwcta_Cte where num_proc_hia in (select num_proc from vwcliente where master='" + ProcessoDT.Rows(0)("num_master").ToString() + "') and dc_hia='C' and cd_tp_Tx='PSA' group by cd_tp_moeda "

        If ltempDT.Rows.Count > 0 Then
            AgentProfitShareAmt = "<Amounts>"
            AgentProfitShareAmt = AgentProfitShareAmt & "<AmountType>" & "AgentProfitShareAmt" & "</AmountType>"
            AgentProfitShareAmt = AgentProfitShareAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            AgentProfitShareAmt = AgentProfitShareAmt & "<AmountUnit>" & "</AmountUnit>"
            AgentProfitShareAmt = AgentProfitShareAmt & "<AmountCurrency>" + ltempDT.Rows(0)("cd_Tp_moeda").ToString() + "</AmountCurrency>"
            AgentProfitShareAmt = AgentProfitShareAmt & "<AmountCode>" & "</AmountCode>"
            AgentProfitShareAmt = AgentProfitShareAmt & "</Amounts>"
        End If




    End Function


    Private Function ConsolDeconsolCostAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select sum(vlr_pgto_Rcto_hia) Valor from vwcxas  where num_proc_hia='" + ProcessoDT.Rows(0)("num_master").ToString() + "' and dc_hia='D' "

        If ltempDT.Rows.Count > 0 Then
            ConsolDeconsolCostAmt = "<Amounts>"
            ConsolDeconsolCostAmt = ConsolDeconsolCostAmt & "<AmountType>" & "ConsolDeconsolCostAmt" & "</AmountType>"
            ConsolDeconsolCostAmt = ConsolDeconsolCostAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            ConsolDeconsolCostAmt = ConsolDeconsolCostAmt & "<AmountUnit>" & "</AmountUnit>"
            ConsolDeconsolCostAmt = ConsolDeconsolCostAmt & "<AmountCurrency>" & "BRL" & "</AmountCurrency>"
            ConsolDeconsolCostAmt = ConsolDeconsolCostAmt & "<AmountCode>" & "</AmountCode>"
            ConsolDeconsolCostAmt = ConsolDeconsolCostAmt & "</Amounts>"
        End If




    End Function

    Private Function ConsolDeconsolRevenueAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select sum(vlr_pgto_Rcto_hia) Valor from vwcxas where num_proc_hia in (select num_proc from vwcliente where master='" + ProcessoDT.Rows(0)("num_master").ToString() + "') and dc_hia='C' "


        If ltempDT.Rows.Count > 0 Then
            ConsolDeconsolRevenueAmt = "<Amounts>"
            ConsolDeconsolRevenueAmt = ConsolDeconsolRevenueAmt & "<AmountType>" & "ConsolDeconsolRevenueAmt" & "</AmountType>"
            ConsolDeconsolRevenueAmt = ConsolDeconsolRevenueAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            ConsolDeconsolRevenueAmt = ConsolDeconsolRevenueAmt & "<AmountUnit>" & "</AmountUnit>"
            ConsolDeconsolRevenueAmt = ConsolDeconsolRevenueAmt & "<AmountCurrency>" & "BRL" & "</AmountCurrency>"
            ConsolDeconsolRevenueAmt = ConsolDeconsolRevenueAmt & "<AmountCode>" & "</AmountCode>"
            ConsolDeconsolRevenueAmt = ConsolDeconsolRevenueAmt & "</Amounts>"
        End If




    End Function

    Private Function ConsolDeconsolCreditAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select sum(vlr_pgto_Rcto_hia) Valor from vwcxas where num_proc_hia in (select num_proc from vwcliente where master='" + ProcessoDT.Rows(0)("num_master").ToString() + "') and dc_hia='C' "

        If ltempDT.Rows.Count > 0 Then
            ConsolDeconsolCreditAmt = "<Amounts>"
            ConsolDeconsolCreditAmt = ConsolDeconsolCreditAmt & "<AmountType>" & "ConsolDeconsolCreditAmt" & "</AmountType>"
            ConsolDeconsolCreditAmt = ConsolDeconsolCreditAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            ConsolDeconsolCreditAmt = ConsolDeconsolCreditAmt & "<AmountUnit>" & "</AmountUnit>"
            ConsolDeconsolCreditAmt = ConsolDeconsolCreditAmt & "<AmountCurrency>" & "BRL" & "</AmountCurrency>"
            ConsolDeconsolCreditAmt = ConsolDeconsolCreditAmt & "<AmountCode>" & "</AmountCode>"
            ConsolDeconsolCreditAmt = ConsolDeconsolCreditAmt & "</Amounts>"
        End If




    End Function

    Private Function ConsolDeconsolNetMarginAmt() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select sum(dbo.valor(vlr_pgto_Rcto_hia,dc_hia)) Valor from vwcxas where (num_proc_hia='" + ProcessoDT.Rows(0)("num_master").ToString() + "' or  num_proc_hia in (select num_proc from vwcliente where master='" + ProcessoDT.Rows(0)("num_master").ToString() + "')) and dc_hia='C' "

        If ltempDT.Rows.Count > 0 Then
            ConsolDeconsolNetMarginAmt = "<Amounts>"
            ConsolDeconsolNetMarginAmt = ConsolDeconsolNetMarginAmt & "<AmountType>" & "ConsolDeconsolNetMarginAmt" & "</AmountType>"
            ConsolDeconsolNetMarginAmt = ConsolDeconsolNetMarginAmt & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("valor").ToString(), "0.00")), ",", ".") & "</AmountValue>"
            ConsolDeconsolNetMarginAmt = ConsolDeconsolNetMarginAmt & "<AmountUnit>" & "</AmountUnit>"
            ConsolDeconsolNetMarginAmt = ConsolDeconsolNetMarginAmt & "<AmountCurrency>" & "BRL" & "</AmountCurrency>"
            ConsolDeconsolNetMarginAmt = ConsolDeconsolNetMarginAmt & "<AmountCode>" & "</AmountCode>"
            ConsolDeconsolNetMarginAmt = ConsolDeconsolNetMarginAmt & "</Amounts>"
        End If




    End Function

    Private Function ForwarderInstructions() As String

        Dim ltempDT As New Data.DataTable
        Dim strTexto As String

        StrSql = "spINTSmart_SEl '" & ProcessoDT.Rows(0)("processo").ToString() & "'"

        ForwarderInstructions = ""
        strTexto = "<![CDATA["" "
        For Each lTempDR As DataRow In ltempDT.Rows
            strTexto = strTexto & Upper_Case(IIf(IsDBNull(lTempDR.Item("saida")) = True, "", lTempDR.Item("saida").ToString())) & vbCrLf
        Next

        strTexto = strTexto & "]]>"
        ForwarderInstructions = "<Notes type='Forwarder Instructions'>" & vbCrLf
        ForwarderInstructions = ForwarderInstructions & strTexto & vbCrLf
        ForwarderInstructions = ForwarderInstructions & "</Notes>"

        ForwarderInstructions = ""


    End Function

    Private Function Transportation_PortofEntry() As String

        Transportation_PortofEntry = ""

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "IM" Then Exit Function

        Transportation_PortofEntry = "<Transportation Responsibility='Carrier' MethodofTransportation='Ocean' LegType='Secondary'>"
        Transportation_PortofEntry = Transportation_PortofEntry & "<Destination LocationType='PortofEntry'>" & vbCrLf
        Transportation_PortofEntry = Transportation_PortofEntry & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationName>" & vbCrLf
        Transportation_PortofEntry = Transportation_PortofEntry & "</Destination>" & vbCrLf
        '   Transportation_PortofEntry = Transportation_PortofEntry + "</DestinationCodeType>" + vbCrLf
        Transportation_PortofEntry = Transportation_PortofEntry & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf
        Transportation_PortofEntry = Transportation_PortofEntry & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
        Transportation_PortofEntry = Transportation_PortofEntry & "</DestinationCodeType>" & vbCrLf
        Transportation_PortofEntry = Transportation_PortofEntry & "</Transportation>"

    End Function

    Private Function Legs() As String

        Dim ltempDT As New Data.DataTable
        Dim strNomeLocal As String
        Dim strUNlocal As String

        Legs = ""

        Legs = "<Legs>" & vbCrLf
        Legs = Legs & "<InterimPointDeptMOT></InterimPointDeptMOT>" & vbCrLf
        Legs = Legs & "<InterimPointDeptVesselName></InterimPointDeptVesselName>" & vbCrLf
        Legs = Legs & "<InterimPointDeptVesselCode></InterimPointDeptVesselCode>" & vbCrLf
        Legs = Legs & "<InterimPointDeptVesFlghtNumber></InterimPointDeptVesFlghtNumber>" & vbCrLf
        Legs = Legs & "<InterimPointDeptCarrierName></InterimPointDeptCarrierName>"
        Legs = Legs & "<InterimPointDeptCarrierSCAC></InterimPointDeptCarrierSCAC>"

        StrSql = "spSmartTranshipmentName_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Legs = Legs & "<InterimPointDeptLocation>" + ltempDT.Rows(0)("Nome_Local").ToString() + "</InterimPointDeptLocation>"
            Legs = Legs & "<InterimPointDeptUNLOCCode>" + ltempDT.Rows(0)("unCode").ToString() + "</InterimPointDeptUNLOCCode>"
            strNomeLocal = ltempDT.Rows(0)("Nome_Local").ToString()
            strUNlocal = ltempDT.Rows(0)("unCode").ToString()

        Else
            Legs = Legs & "<InterimPointDeptLocation></InterimPointDeptLocation>"
            Legs = Legs & "<InterimPointDeptUNLOCCode></InterimPointDeptUNLOCCode>"
        End If

        'Erbson Nova vers�o
        'RsTemp = Nothing

        StrSql = "spSmartTransshipment_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = New DataTable()
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        If ltempDT.Rows.Count > 0 Then

            Legs = Legs & "<InterimPointEstDepartureDate>" & VB6.Format(ltempDT.Rows(0)("dt_previsao").ToString(), "yyyymmdd") & "</InterimPointEstDepartureDate>"
            Legs = Legs & "<InterimPointEstDepartureTime></InterimPointEstDepartureTime>"


            If IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = False Then
                Legs = Legs & "<InterimPointActDepartureDate>" & VB6.Format(ltempDT.Rows(0)("dt_conclusao").ToString(), "yyyymmdd") & "</InterimPointActDepartureDate>"
            Else
                Legs = Legs & "<InterimPointActDepartureDate></InterimPointActDepartureDate>"
            End If
            Legs = Legs & "<InterimPointActDepartureTime></InterimPointActDepartureTime>"

            If strUNlocal <> "" Then
                Legs = Legs & "<InterimPointArrvLocation>" & Upper_Case(strNomeLocal) & "</InterimPointArrvLocation>"
                Legs = Legs & "<InterimPointArrvUNLOCCode>" & strUNlocal & "</InterimPointArrvUNLOCCode>"
            Else
                Legs = Legs & "<InterimPointArrvLocation></InterimPointArrvLocation>"
                Legs = Legs & "<InterimPointArrvUNLOCCode></InterimPointArrvUNLOCCode>"

            End If


            If ltempDT.Rows.Count > 1 Then

                If IsDBNull(ltempDT.Rows(1)("dt_conclusao")) = False Then
                    Legs = Legs & "<InterimPointEstArrivalDate>" & VB6.Format(ltempDT.Rows(1)("dt_previsao").ToString(), "yyyymmdd") & "</InterimPointEstArrivalDate>"
                    Legs = Legs & "<InterimPointEstArrivalTime></InterimPointEstArrivalTime>"
                    Legs = Legs & "<InterimPointActArrivalDate>" & VB6.Format(ltempDT.Rows(1)("dt_conclusao").ToString(), "yyyymmdd") & "</InterimPointActArrivalDate>"
                Else
                    Legs = Legs & "<InterimPointEstArrivalDate></InterimPointEstArrivalDate>"
                    Legs = Legs & "<InterimPointEstArrivalTime></InterimPointEstArrivalTime>"
                    Legs = Legs & "<InterimPointActArrivalDate></InterimPointActArrivalDate>"
                End If
            End If

            Legs = Legs & "<InterimPointActArrivalTime></InterimPointActArrivalTime>"
            Legs = Legs & "<InterimPointBolAwbNumber></InterimPointBolAwbNumber>"
            Legs = Legs & "<InterimPointRefNo></InterimPointRefNo>"
            Legs = Legs & "<InterimPointStatusText></InterimPointStatusText>"
            Legs = Legs & "<InterimPointStatusDate></InterimPointStatusDate>"
            Legs = Legs & "</Legs>"

        Else
            Legs = ""
            Exit Function
        End If




    End Function

    Private Function Transportation_PlaceofDelivery() As String

        Transportation_PlaceofDelivery = ""

        If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then Exit Function

        Transportation_PlaceofDelivery = "<InlandCarrier>" & Armador() & "</InlandCarrier>"

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "A"
                Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='A' LegType='Secondary'>"
            Case "M"
                Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='Ocean' LegType='Secondary'>"
            Case "O"
                If ProcessoDT.Rows(0)("Tipo_Tranp").ToString() = "T" Then
                    Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='T' LegType='Secondary'>"
                Else
                    Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='R' LegType='Secondary'>"
                End If
        End Select

        If PlaceofReceipt() <> "" Then
            Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & PlaceofReceipt()
        End If

        If strProcesso.Substring(0, 2) = "EM" And StrType = "301" Then

            If ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDP" And ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DAP" Then

                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<Destination LocationType='PlaceofDelivery'>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then
                    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationName>" & vbCrLf
                Else
                    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_destino").ToString()) & "</DestinationName>" & vbCrLf
                End If
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Destination>" & vbCrLf

                '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery + "</DestinationCodeType>" + vbCrLf
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then
                    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
                Else
                    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_destino").ToString()) & "</DestinationCode>" & vbCrLf
                End If
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</DestinationCodeType>" & vbCrLf
                'Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Transportation>"
            End If
        Else

            Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<Destination LocationType='PlaceofDelivery'>" & vbCrLf

            If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationName>" & vbCrLf
            Else
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_destino").ToString()) & "</DestinationName>" & vbCrLf
            End If
            Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Destination>" & vbCrLf

            '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery + "</DestinationCodeType>" + vbCrLf
            Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf

            If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
            Else
                Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_destino").ToString()) & "</DestinationCode>" & vbCrLf
            End If
            Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</DestinationCodeType>" & vbCrLf
            'Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Transportation>"
        End If

        Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Transportation>"

    End Function

    'Private Function Transportation_PlaceofDelivery() As String

    '    Transportation_PlaceofDelivery = ""

    '    If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then Exit Function


    '    Transportation_PlaceofDelivery = "<InlandCarrier>" & Armador() & "</InlandCarrier>"

    '    Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
    '        Case "A"
    '            Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='A' LegType='Secondary'>"
    '        Case "M"
    '            Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='Ocean' LegType='Secondary'>"
    '        Case "O"
    '            If ProcessoDT.Rows(0)("Tipo_Tranp").toString() = "T" Then
    '                Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='T' LegType='Secondary'>"
    '            Else
    '                Transportation_PlaceofDelivery = "<Transportation Responsibility='Carrier' MethodofTransportation='R' LegType='Secondary'>"
    '            End If
    '    End Select

    '    If PlaceofReceipt() <> "" Then
    '        Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & PlaceofReceipt()
    '    End If

    '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<Destination LocationType='PlaceofDelivery'>" & vbCrLf

    '    If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then
    '        Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_dst").toString()) & "</DestinationName>" & vbCrLf
    '    Else
    '        Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationName>" & Nome_Local(ProcessoDT.Rows(0)("cd_destino").toString()) & "</DestinationName>" & vbCrLf
    '    End If
    '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Destination>" & vbCrLf
    '    '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery + "</DestinationCodeType>" + vbCrLf
    '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf

    '    If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = True Then
    '        Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").toString()) & "</DestinationCode>" & vbCrLf
    '    Else
    '        Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_destino").toString()) & "</DestinationCode>" & vbCrLf
    '    End If
    '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</DestinationCodeType>" & vbCrLf
    '    Transportation_PlaceofDelivery = Transportation_PlaceofDelivery & "</Transportation>"

    'End Function


    Private Function ProductFees(ByRef strPRoduto As String) As String

        Dim ltempDT As New Data.DataTable
        Dim IntI As Short

        StrSql = "spIntSmartTaxaPPRoduto_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "','" + strPRoduto + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        IntI = 1


        ProductFees = ""
        For Each lTempDR As DataRow In ltempDT.Rows


            ProductFees = ProductFees & "<ProductFees>"

            ProductFees = ProductFees & "<Description>" & Upper_Case(IIf(IsDBNull(lTempDR.Item("taxa")) = True, "", lTempDR.Item("taxa").ToString())) & "</Description>"
            ProductFees = ProductFees & "<Code>" + lTempDR.Item("cd_tp_Tx").ToString() + "</Code>"
            ProductFees = ProductFees & "<Amount>" & Replace(CStr(VB6.Format(lTempDR.Item("vlr_item_custo").ToString(), "0.00")), ",", ".") & "</Amount>"
            ProductFees = ProductFees & "<SeqNumber>" & CStr(IntI) & "</SeqNumber>"
            ProductFees = ProductFees & "</ProductFees>"
            IntI = IntI + 1

        Next



    End Function

    Private Function Duty() As String

        Duty = "<Duty>" & vbCrLf
        Duty = Duty & "<Amount>0000</Amount>" & vbCrLf
        Duty = Duty & "</Duty>"
    End Function

    Private Function SBU(ByRef strGMID As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select Value_center_code Codigo from de_para_produto with(nolock) where gmid='" & strGMID & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("codigo")) = True Then
                SBU = ""
            Else
                SBU = "<ProductReferences type='SBU'>" & vbCrLf
                SBU = SBU & "<ProductReferenceNumber>" + ltempDT.Rows(0)("codigo").ToString() + "</ProductReferenceNumber>"
                SBU = SBU & "</ProductReferences>"
            End If
        Else
            SBU = ""
        End If


    End Function

    Private Function Sem_Produto() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select [dbo].[RemoveNonAlphaCharacters](Descr) Descr From Nature_Goods with(nolock) where num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        Sem_Produto = "<ProductDetail>" & vbCrLf
        Sem_Produto = Sem_Produto & "<LineItemNo>1</LineItemNo>" & vbCrLf
        If ltempDT.Rows.Count > 0 Then
            'Sem_Produto = Sem_Produto & "<InvoiceDesc>" + Upper_Case(ltempDT.Rows(0)("descr").ToString()) + "</InvoiceDesc>"
            Sem_Produto = Sem_Produto & "<InvoiceDesc><![CDATA[" & Upper_Case(ltempDT.Rows(0)("descr").ToString()) & "]]></InvoiceDesc>"
            Sem_Produto = Sem_Produto & "<NoOfPkgs>" & CStr(ProcessoDT.Rows(0)("qtd_tot_vol").ToString()) & "</NoOfPkgs>"
        End If

        Sem_Produto = Sem_Produto & "<Measurements type='GrsWtKgs'>"

        Sem_Produto = Sem_Produto & "<MeasurementValue>" & Replace(IIf(IsDBNull(ProcessoDT.Rows(0)("Peso_Bruto")) = True, 0, ProcessoDT.Rows(0)("Peso_Bruto").ToString()), ",", ".") & "</MeasurementValue>" & vbCrLf
        Sem_Produto = Sem_Produto & "</Measurements>" & vbCrLf
        Sem_Produto = Sem_Produto & "<Measurements type='NetWtKgs'>" & vbCrLf

        Sem_Produto = Sem_Produto & "<MeasurementValue>" & Replace(IIf(IsDBNull(ProcessoDT.Rows(0)("peso_liquido")) = True, 0, ProcessoDT.Rows(0)("peso_liquido").ToString()), ",", ".") & "</MeasurementValue>"
        Sem_Produto = Sem_Produto & "</Measurements>"
        Sem_Produto = Sem_Produto & "</ProductDetail>"

    End Function

    Private Function UserDow(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable
        StrSql = "spINTUserDow '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        UserDow = ""
        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("PO")) = False Or IsDBNull(ltempDT.Rows(0)("usuario")) = False Then
                UserDow = "<Party-Contacts Action='Add' type='CSR'>"

                If IsDBNull(ltempDT.Rows(0)("usuario")) = False And Trim(ltempDT.Rows(0)("usuario").ToString()) <> "" Then
                    UserDow = UserDow & "<Contact-Name>" & Replace(Replace(Upper_Case(ltempDT.Rows(0)("usuario").ToString()), "", ""), ",", ", ") & "</Contact-Name>" & vbCrLf
                Else

                    UserDow = UserDow & "<Contact-Name>" & Replace(Replace(Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("PO")) = True, "NO REF#", ltempDT.Rows(0)("PO").ToString())), "", ""), ",", ", ") & "</Contact-Name>" & vbCrLf
                End If
                UserDow = UserDow & "<Contact-CommunicationAddress type='Email'></Contact-CommunicationAddress>" & vbCrLf
                UserDow = UserDow & "</Party-Contacts>"

            End If
        End If

        If UserDow = "" Then
            UserDow = "<Party-Contacts Action='Add' type='CSR'>"
            UserDow = UserDow & "<Contact-Name>" & "NO REF#" & "</Contact-Name>" & vbCrLf
            UserDow = UserDow & "<Contact-CommunicationAddress type='Email'></Contact-CommunicationAddress>" & vbCrLf
            UserDow = UserDow & "</Party-Contacts>"
        End If
    End Function

    Private Function Customer_Representative(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable
        StrSql = "spINTUserDow '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Customer_Representative = ""
        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("CSR")) = False Then
                Customer_Representative = "<Party-Contacts Action='Add' type='CusRep'>"
                Customer_Representative = Customer_Representative & "<Contact-Name>" & Upper_Case(ltempDT.Rows(0)("CSR").ToString()) & "</Contact-Name>" & vbCrLf
                Customer_Representative = Customer_Representative & "<Contact-CommunicationAddress type='Email'></Contact-CommunicationAddress>" & vbCrLf
                Customer_Representative = Customer_Representative & "</Party-Contacts>"

            End If
        End If

    End Function

    Private Function Busca_Planta() As String


        Dim ltempDT As New Data.DataTable

        StrSql = "spINTPlanta '" & ProcessoDT.Rows(0)("processo").ToString() & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I" Then

                If IsDBNull(ltempDT.Rows(0)("planta_pedido")) = False Then
                    Busca_Planta = ltempDT.Rows(0)("planta_pedido").ToString()
                Else

                    Busca_Planta = IIf(IsDBNull(ltempDT.Rows(0)("planta_buyer")) = True, "", ltempDT.Rows(0)("planta_buyer").ToString())
                End If
            Else

                If IsDBNull(ltempDT.Rows(0)("Planta_Seller")) = False Then
                    Busca_Planta = ltempDT.Rows(0)("Planta_Seller").ToString()
                Else

                    Busca_Planta = IIf(IsDBNull(ltempDT.Rows(0)("planta_pedido")) = True, "", ltempDT.Rows(0)("planta_pedido").ToString())
                End If
            End If
        Else
            Busca_Planta = ""
        End If

    End Function


    Private Function Inicio() As String

        Inicio = "<?xml version=""1.0"" encoding=""ISO-8859-1"" ?>" & vbCrLf
        Inicio = Inicio & "<Request>" & vbCrLf

        'Dim IntMS As String = "00" + DateTime.UtcNow.Millisecond.ToString()
        'IntMS = IntMS.Substring(IntMS.Length - 3, 3)

        Dim Data As String = DateTime.UtcNow.ToShortDateString()

        Dim G As Guid

        G = Guid.NewGuid()
        Data = "{" + G.ToString() + "}"
        If StrType.Equals("301") Then

            Inicio = Inicio + "<ControlNumber>" + G.ToString() + "</ControlNumber>" & vbCrLf
            Inicio = Inicio + "<UniqueMessageID>" + G.ToString() + "</UniqueMessageID>" & vbCrLf
            Inicio = Inicio + "<FromIdentifier>" + strFromIdentifier + "</FromIdentifier>" & vbCrLf
            Inicio = Inicio + "<ToIdentifier>" + strToIdentifier + "</ToIdentifier>" & vbCrLf
            Inicio = Inicio + "<Customer>" + strCustomer + "</Customer>" & vbCrLf
            Inicio = Inicio + "<Timestamp>" + DateTime.UtcNow.ToString("s").Replace("-", "").Replace(":", "") + "</Timestamp>" & vbCrLf
            Inicio = Inicio + "<PrimaryKey>" + strLevisISD + "</PrimaryKey>" & vbCrLf
            Inicio = Inicio + "<SecondaryKey>" + strProcesso + "</SecondaryKey>" & vbCrLf
        ElseIf StrType.Equals("ShippingInstruction") Then
            Inicio = Inicio + "<ControlNumber>" + G.ToString() + "</ControlNumber>" & vbCrLf
            Inicio = Inicio + "<UniqueMessageID>" + G.ToString() + "</UniqueMessageID>" & vbCrLf
            Inicio = Inicio + "<FromIdentifier>" + strFromIdentifier + "</FromIdentifier>" & vbCrLf
            Inicio = Inicio + "<ToIdentifier>" + strToIdentifier + "</ToIdentifier>" & vbCrLf
            Inicio = Inicio + "<Customer>" + strCustomer + "</Customer>" & vbCrLf
            Inicio = Inicio + "<Timestamp>" + DateTime.UtcNow.ToString("s").Replace("-", "").Replace(":", "") + "</Timestamp>" & vbCrLf
            Inicio = Inicio + "<PrimaryKey>" + strProcesso + "</PrimaryKey>" & vbCrLf
            Inicio = Inicio + "<SecondaryKey>" + DateTime.Now.ToString("yyyyMMddhhmmssfff") + "</SecondaryKey>" & vbCrLf
        End If

        If strConsol = "Y" Then
            Inicio = Inicio & "<Header RequestType=""Shipment"" Action='Original' Type='Consol'>"
        ElseIf StrType.Equals("ShippingInstruction") Then
            Inicio = Inicio & "<Header RequestType=""BookingRequest"" Action=""" & strTipo & """ Type=""Export"">"
        Else
            Select Case UCase(VB.Left(strProcesso, 1))

                Case "E"
                    Inicio = Inicio & "<Header RequestType=""Shipment"" Action=""" & strTipo & """ Type=""Export"">"
                    'Inicio = Inicio + "<Header RequestType=""Shipment"" Action=""Cancel"" Type=""Export"">"

                Case "I"
                    'Inicio = Inicio + "<Header RequestType=""Shipment"" Action=""Cancel"" Type=""Import"">"
                    Inicio = Inicio & "<Header RequestType=""Shipment"" Action=""" & strTipo & """ Type=""Import"">"

                Case "B"
                    'Inicio = Inicio + "<Header RequestType=""Shipment"" Action=""Cancel"" Type=""Import"">"
                    Inicio = Inicio & "<Header RequestType=""Shipment"" Action=""" & strTipo & """ Type=""Import"">"


            End Select
        End If

        '     tstream.WriteLine ("teste")

    End Function
    Private Function BDPCliente() As String

        Dim StrPes As String
        Dim ltempDT As New Data.DataTable

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then
            StrPes = ProcessoDT.Rows(0)("cd_consig").ToString()
        Else
            StrPes = ProcessoDT.Rows(0)("cd_Export").ToString()
        End If

        StrSql = "spIntPessoa_Sel '" & StrPes & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "E" Then

                StrPes = IIf(IsDBNull(ltempDT.Rows(0)("smart_exp")) = True, "", Trim(ltempDT.Rows(0)("smart_exp").ToString()))
            Else

                StrPes = IIf(IsDBNull(ltempDT.Rows(0)("smart_imp")) = True, "", Trim(ltempDT.Rows(0)("smart_imp").ToString()))
            End If
        End If
        BDPCliente = "<References type='BDPClientCode'>"
        BDPCliente = BDPCliente & "<ReferenceNumber>" & StrPes & "</ReferenceNumber>"
        BDPCliente = BDPCliente & " </References>"



    End Function
    Private Function OperatingUnitClassification() As String

        Dim StrPes As String
        Dim ltempDT As New Data.DataTable

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then
            StrPes = ProcessoDT.Rows(0)("cd_consig").ToString()
        Else
            StrPes = ProcessoDT.Rows(0)("cd_Export").ToString()
        End If

        StrSql = "select Campo_dados from campo_processo with(nolock) where num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "' and id_campo=32"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            StrPes = "CHB"
        Else
            If ltempDT.Rows(0)("campo_dados").ToString() = "1" Then
                StrPes = "CHB"
            Else
                StrPes = "FFD"
            End If
        End If



        OperatingUnitClassification = "<References type='OperatingUnitClassification'>"
        OperatingUnitClassification = OperatingUnitClassification & "<ReferenceNumber>" & StrPes & "</ReferenceNumber>"
        OperatingUnitClassification = OperatingUnitClassification & " </References>"



    End Function
    Private Function AddShipPoint() As String


        '- <ReferenceType type="AdditionalShipPoint">
        '  <ReferenceNumber>D146</ReferenceNumber>
        '  </ReferenceType>

        Dim ltempDT As New Data.DataTable
        StrSql = "spIntAddPoint301_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
                Exit Function
            Else
                AddShipPoint = "<ReferenceType type='AdditionalShipPoint'>"
                AddShipPoint = AddShipPoint & "<ReferenceNumber>" + ltempDT.Rows(0)("numero").ToString() + "</ReferenceNumber>"
                AddShipPoint = AddShipPoint & "</ReferenceType>"
            End If
        End If



    End Function

    Private Function Pessoa(ByRef strTipo As String, ByRef StrPessoa As String) As String

        Dim ltempDT As New Data.DataTable
        '  Dim StrPessoa As String
        Dim StrPais As String

        Select Case strTipo

            'Shipping Instructions In
            Case "Shipper"
                Pessoa = "<Parties type=""Shipper"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
            Case "ExporterShipper"
                Pessoa = "<Parties type=""ExporterShipper"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
            'Shipping Instructions End

            Case "Exportador"
                Pessoa = "<Parties type=""Exporter"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
            Case "Consignee"
                Pessoa = "<Parties type=""Consignee"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
            Case "Importer"
                Pessoa = "<Parties type=""Importer"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
            Case "AlsoNotify"
                Pessoa = "<Parties type=""AlsoNotify"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())


            Case "Soldto"
                Pessoa = "<Parties type=""SoldTo"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
            Case "Notify"
                Pessoa = "<Parties type=""Notify"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
            Case "Plant"
                Pessoa = "<Parties type=""Plant"">" & vbCrLf
                If VB.Left(strProcesso, 1) = "E" Then
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
                Else
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
                End If
            Case "Buyer"
                Pessoa = "<Parties type=""Buyer"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())

            Case "ShipTo"
                Pessoa = "<Parties type=""ShipTo"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
            Case "Seller"
                Pessoa = "<Parties type=""Seller"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
            Case "Supplier"
                Pessoa = "<Parties type=""Supplier"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
            Case "BDPRepresentative"
                Pessoa = "<Parties type=""BDPRepresentative"">" & vbCrLf
                If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
                Else
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
                End If
            Case "ClearingAgent"
                Pessoa = "<Parties type=""ClearingAgent"">" & vbCrLf
                If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
                Else
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
                End If
            Case "GlobalAgent"
                Pessoa = "<Parties type=""GlobalAgent"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())

            Case "Forwarder"
                Pessoa = "<Parties type=""Forwarder"">" & vbCrLf
                If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
                Else
                    StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
                End If

            Case "ShipFrom"
                Pessoa = "<Parties type=""ShipFrom"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_org").ToString())
                strTipo = "Shipper"

            Case "DeliverTo"
                Pessoa = "<Parties type=""DeliverTo"">" & vbCrLf
                StrPais = Pais(ProcessoDT.Rows(0)("cd_dst").ToString())
                strTipo = "Consignee"
        End Select

        If StrType = "ShippingInstruction" And (strTipo = "Notify" Or strTipo = "Consignee" Or strTipo = "ExporterShipper" Or strTipo = "Shipper") Then
            Pessoa = Pessoa & Pessoa_Altera_BL(strProcesso, strTipo)
        Else

            StrSql = "spIntPessoa_Sel '" & StrPessoa & "' " '"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            If ltempDT.Rows.Count = 0 Then Exit Function

            If strTipo = "Plant" Then

                Pessoa = Pessoa & "<Party-Name>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("planta_nome")) = True, ltempDT.Rows(0)("nome_raz_soc").ToString(), ltempDT.Rows(0)("planta_nome").ToString())) & "</Party-Name>" & vbCrLf
            Else
                Pessoa = Pessoa & "<Party-Name>" & Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString()) & "</Party-Name>" & vbCrLf
            End If

            Pessoa = Pessoa & "<Party-Address>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("endereco")) = True, "", ltempDT.Rows(0)("endereco").ToString())) & "</Party-Address>" & vbCrLf

            Pessoa = Pessoa & "<Party-City>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cidade")) = True, "", ltempDT.Rows(0)("cidade").ToString())) & "</Party-City>" & vbCrLf

            Pessoa = Pessoa & "<Party-State-Prov>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("uf")) = True, "", ltempDT.Rows(0)("uf").ToString())) & "</Party-State-Prov>" & vbCrLf

            Pessoa = Pessoa & "<Party-PostalCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cep")) = True, "", ltempDT.Rows(0)("cep").ToString())) & "</Party-PostalCode>" & vbCrLf

            Pessoa = Pessoa & "<Party-Country>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cd_pais")) = True, "", ltempDT.Rows(0)("cd_pais").ToString())) & "</Party-Country>" & vbCrLf

            If strTipo = "Plant" Then
                Pessoa = CStr(Pessoa & "<Party-ID type='PlantCode'>" + IIf(Busca_Planta() = "", "05031", Busca_Planta) + "</Party-ID>" + vbCrLf)
            End If



            If (strTipo = "Consignee" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Or (strTipo = "Exportador" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E") Or (strTipo = "Buyer" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Or (strTipo = "Importer" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Then
                If (strTipo = "Consignee" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Or (strTipo = "Buyer" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Or (strTipo = "Importer" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Then
                    If UCase(strArgTP) <> "SEA" Then

                        Pessoa = Pessoa & "<PartyLocation-ID>" & IIf(IsDBNull(ltempDT.Rows(0)("smart_imp")) = True, "BDP", Trim(ltempDT.Rows(0)("smart_imp").ToString())) & "</PartyLocation-ID>" & vbCrLf
                    Else
                        Pessoa = Pessoa & "<PartyLocation-ID>" + ltempDT.Rows(0)("codigo").ToString() + "</PartyLocation-ID>" + vbCrLf
                    End If
                Else


                    Pessoa = CStr(Pessoa & "<PartyLocation-ID>" + IIf(IsDBNull(ltempDT.Rows(0)("smart_exp")) = True, "BDP", Trim(ltempDT.Rows(0)("smart_exp").ToString())) + "</PartyLocation-ID>" + vbCrLf)

                End If
            Else
                If StrType = "301" And (strTipo = "Buyer" Or strTipo = "Consignee" Or strTipo = "ShipTo" Or strTipo = "Importer") Then
                    Pessoa = Pessoa & "<PartyLocation-ID>" + ltempDT.Rows(0)("Cd_Vendor").ToString() + "</PartyLocation-ID>" + vbCrLf
                Else
                    Pessoa = Pessoa & "<PartyLocation-ID>" + ltempDT.Rows(0)("codigo").ToString() + "</PartyLocation-ID>" + vbCrLf
                End If
            End If

            If (strTipo = "Exportador" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E") Or (strTipo = "Consignee" And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Then
                'Regra Inserida por Erbson 19/08/2015 - N�o utilizar par ao 301
                If (StrType.Equals("301") = False) Then
                    Pessoa = Pessoa & UserDow(ProcessoDT.Rows(0)("processo").ToString())
                    Pessoa = Pessoa & Customer_Representative(ProcessoDT.Rows(0)("processo").ToString())
                End If
            End If

            'EM VALIDACAO COM FEDER 07/01/2014


            If IsDBNull(ltempDT.Rows(0)("GLOBAL_ENTITY_ID")) = False Then
                If ((strTipo = "Exportador" Or strTipo = "Seller" Or strTipo = "Shipper") And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E") Or ((strTipo = "Consignee" Or strTipo = "Buyer" Or strTipo = "Importer") And VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I") Then 'Or (Mid$(RsProcesso!processo, 3, 3) = "SMG" And Right(RsProcesso!processo, 2) = "AR") Then

                    Pessoa = CStr(Pessoa & "<Party-GlobalCode>" + IIf(IsDBNull(ltempDT.Rows(0)("GLOBAL_ENTITY_ID")) = True, "", ltempDT.Rows(0)("GLOBAL_ENTITY_ID").ToString()) + "</Party-GlobalCode>")
                End If

            End If



            Pessoa = Pessoa & "<Party-CountryName>" & IIf(IsDBNull(ltempDT.Rows(0)("Pais")) = True, "", ltempDT.Rows(0)("Pais").ToString()) & "</Party-CountryName>" & vbCrLf


            Pessoa = CStr(Pessoa & "<Party-UnlocCode>" + IIf(IsDBNull(ltempDT.Rows(0)("cd_pais")) = True, "", ltempDT.Rows(0)("cd_pais").ToString()) + Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("SCAC")) = True, "", ltempDT.Rows(0)("SCAC").ToString())) + "</Party-UnlocCode>")


            '    If StrTipo = "Exportador" And Left(RsProcesso!Processo, 5) <> "EOCSR" Then
            '        StrSql = "spCSRJob_SEL '" & StrProcesso & "'"
            '        RsCSR.Open StrSql, Conexao, adOpenForwardOnly, adLockReadOnly
            '        If RsCSR.EOF = False Then
            '            Pessoa = Pessoa + "<Party-Contacts Action='' type=""CSR"">" + vbCrLf
            '            Pessoa = Pessoa + "<Contact-Name>" + Upper_Case(RsCSR!nome_usuario) + "</Contact-Name>" + vbCrLf
            '            Pessoa = Pessoa + "<Contact-CommunicationAddress type=""Email"">" + RsCSR!email + "</Contact-CommunicationAddress>" + vbCrLf
            '            Pessoa = Pessoa + "</Party-Contacts>"
            '        End If
            '        RsCSR.Close
            '    End If



            If IsDBNull(ltempDT.Rows(0)("cnpj")) = False Then

                Pessoa = Pessoa & "<GovIDNumber>" & Replace(ltempDT.Rows(0)("cnpj").ToString(), " ", "") & "</GovIDNumber>" & vbCrLf
            End If
            If strTipo = "Partner" Or strTipo = "BDPRepresentative" Then
                Pessoa = Pessoa & CSR_Contact()
            End If

        End If

        Pessoa = Pessoa & "</Parties>"

    End Function

    Private Function CSR_Manager() As String

        '    CSR_Manager = ""
        '    CSR_Manager = CSR_Manager + "<Party-Contacts Action='' type=""AccountManager"">" + vbCrLf
        '    Select Case StrPais
        '        Case "Argentina"
        '            CSR_Manager = CSR_Manager + "<Contact-Name>" + "Marcia Silva" + "</Contact-Name>" + vbCrLf
        '            CSR_Manager = CSR_Manager + "<Contact-CommunicationAddress type=""Email"">" + "msans@bdpinternational.com.ar" + "</Contact-CommunicationAddress>" + vbCrLf
        '            CSR_Manager = CSR_Manager + "<Contact-CommunicationAddress type=""Phone"">" + "" + "</Contact-CommunicationAddress>" + vbCrLf
        '        Case "Brasil"
        '            CSR_Manager = CSR_Manager + "<Contact-Name>" + "Pedro Figueira" + "</Contact-Name>" + vbCrLf
        '            CSR_Manager = CSR_Manager + "<Contact-CommunicationAddress type=""Email"">" + "pmello@bdp.com.br" + "</Contact-CommunicationAddress>" + vbCrLf
        '            CSR_Manager = CSR_Manager + "<Contact-CommunicationAddress type=""Phone"">" + "55 11 5504-3408" + "</Contact-CommunicationAddress>" + vbCrLf
        '        Case "Chile"
        '            CSR_Manager = CSR_Manager + "<Contact-Name>" + "Ana Maria Penha" + "</Contact-Name>" + vbCrLf
        '            CSR_Manager = CSR_Manager + "<Contact-CommunicationAddress type=""Email"">" + "" + "</Contact-CommunicationAddress>" + vbCrLf
        '            CSR_Manager = CSR_Manager + "<Contact-CommunicationAddress type=""Phone"">" + "" + "</Contact-CommunicationAddress>" + vbCrLf
        '
        '    End Select
        '    CSR_Manager = CSR_Manager + "</Party-Contacts>"

        Dim csrDT As New DataTable()


        CSR_Manager = ""
        StrSql = "spCSRJob_SEL '" & strProcesso & "'"
        csrDT = sqlCnn.BuscaInformacoes(StrSql)
        If csrDT.Rows.Count > 0 Then
            CSR_Manager = CSR_Manager & "<Party-Contacts Action='' type=""CSR"">" & vbCrLf
            CSR_Manager = CSR_Manager & "<Contact-Name>" & Upper_Case(csrDT.Rows(0)("nome_usuario").ToString()) & "</Contact-Name>" & vbCrLf
            CSR_Manager = CSR_Manager & "<Contact-CommunicationAddress type=""Email"">![CDATA[" + csrDT.Rows(0)("Email").ToString() + "]</Contact-CommunicationAddress>" + vbCrLf
            'If (Not (String.IsNullOrEmpty(RsCsr.Fields("Fone").toString()))) Then
            '    CSR_Manager = CSR_Manager & "<Contact-CommunicationAddress type=""Telephone"">![CDATA[" + RsCsr.Fields("Fone").toString() + "]</Contact-CommunicationAddress>" + vbCrLf
            'End If
            CSR_Manager = CSR_Manager & "</Party-Contacts>"
        End If

        '    CSR_Contact = ""


    End Function

    Private Function Pais(ByRef strLocal As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select top 1 cd_pais from localidade with(nolock) where cd_local='" & strLocal & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            Pais = "AR"
            Exit Function
        End If


        Pais = IIf(IsDBNull(ltempDT.Rows(0)("cd_pais")) = True, "", ltempDT.Rows(0)("cd_pais").ToString())


    End Function
    Private Function Nome_Pais(ByRef strLocal As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select top 1 Pais_Local from localidade with(nolock) where cd_local='" & strLocal & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)



        Nome_Pais = Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Pais_Local")) = True, "", ltempDT.Rows(0)("Pais_Local").ToString()))



    End Function
    Private Function Plant() As String

        Dim ltempDT As New Data.DataTable

        Plant = ""

        StrSql = "select campo_dados from campo_processo where id_Campo=1 and num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If String.IsNullOrEmpty(ltempDT.Rows(0)("Campo_Dados").ToString()) = False Then
                Plant = Pessoa("Plant", ltempDT.Rows(0)("Campo_Dados").ToString())
            End If
        End If

    End Function


    Private Function Partner() As String

        Dim ltempDT As New Data.DataTable

        Select Case StrPais
            Case "Argentina"
                StrSql = "spintPessoa_Sel 'P15498'"
                If strArgTP = "SEA" Then
                    StrSql = "spintPessoa_Sel 'P4'"
                End If
            Case "Brasil"
                StrSql = "spintPessoa_Sel '10017'"
            Case "Chile"
                StrSql = "spintPessoa_Sel 'P10050'"

        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Partner = "<Parties type=""Partner"">" & vbCrLf
        Partner = Partner & "<Party-Name>" & Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString()) & "</Party-Name>" & vbCrLf

        Partner = Partner & "<Party-Address>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("endereco")) = True, "", ltempDT.Rows(0)("endereco").ToString())) & "</Party-Address>" & vbCrLf

        Partner = Partner & "<Party-City>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cidade")) = True, "", ltempDT.Rows(0)("cidade").ToString())) & "</Party-City>" & vbCrLf

        Partner = Partner & "<Party-State-Prov>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("uf")) = True, "", ltempDT.Rows(0)("uf").ToString())) & "</Party-State-Prov>" & vbCrLf

        Partner = Partner & "<Party-PostalCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cep")) = True, "", ltempDT.Rows(0)("cep").ToString())) & "</Party-PostalCode>" & vbCrLf
        Select Case StrPais
            Case "Argentina"
                Partner = Partner & "<Party-Country>AR</Party-Country>" & vbCrLf
                Partner = Partner & "<Party-ID type=""PartnerID"">BDPARBUE</Party-ID>"
            Case "Brasil"
                Partner = Partner & "<Party-Country>BR</Party-Country>" & vbCrLf
                Partner = Partner & "<Party-ID type=""PartnerID"">BDPBRSAO</Party-ID>"
            Case "Chile"
                Partner = Partner & "<Party-Country>BR</Party-Country>" & vbCrLf
                Partner = Partner & "<Party-ID type=""PartnerID"">BDPCLSCL</Party-ID>"
        End Select
        Partner = Partner & CSR_Contact()
        Partner = Partner & "</Parties>"

    End Function
    Private Function Upper_Case(ByRef strTexto As String) As String

        Upper_Case = Replace(UCase(strTexto), "�", "A")
        Upper_Case = Replace(Upper_Case, "�", " ")
        Upper_Case = Replace(UCase(Upper_Case), "�", "O")
        Upper_Case = Replace(UCase(Upper_Case), "�", "C")
        Upper_Case = Replace(UCase(Upper_Case), "&", "E")
        Upper_Case = Replace(UCase(Upper_Case), "�", "E")
        Upper_Case = Replace(UCase(Upper_Case), "�", "O")
        Upper_Case = Replace(UCase(Upper_Case), "�", "A")
        Upper_Case = Replace(UCase(Upper_Case), "�", "U")
        Upper_Case = Replace(UCase(Upper_Case), "�", "I")
        Upper_Case = Replace(UCase(Upper_Case), "'", " ")
        Upper_Case = Replace(UCase(Upper_Case), "�", "E")
        Upper_Case = Replace(UCase(Upper_Case), "�", "O")
        Upper_Case = Replace(UCase(Upper_Case), "�", "A")
        Upper_Case = Replace(UCase(Upper_Case), "�", "U")
        Upper_Case = Replace(UCase(Upper_Case), "'", " ")
        Upper_Case = Replace(UCase(Upper_Case), "�", " ")
        Upper_Case = Replace(UCase(Upper_Case), """", " ")
        Upper_Case = Replace(UCase(Upper_Case), ">", " ")
        Upper_Case = Replace(UCase(Upper_Case), "<", " ")
        Upper_Case = Replace(UCase(Upper_Case), "�", " ")
        Upper_Case = Replace(UCase(Upper_Case), "&", " ")
        Upper_Case = Replace(UCase(Upper_Case), Chr(176), " ")
    End Function

    Private Function Forwarder() As String

        Dim ltempDT As New Data.DataTable
        Dim strCdPes As String

        Select Case StrPais
            Case "Argentina"
                StrSql = "spintPessoa_Sel 'P15498'"
                strCdPes = "P15498"
                If strArgTP = "SEA" Then
                    StrSql = "spintPessoa_Sel 'P4'"
                    strCdPes = "P4"
                End If
            Case "Brasil"
                StrSql = "spintPessoa_Sel '10017'"
                strCdPes = "10017"
            Case "Chile"
                StrSql = "spintPessoa_Sel 'P10050'"
                strCdPes = "P10050"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Forwarder = "<Parties type=""Forwarder"">" & vbCrLf
        Forwarder = Forwarder & "<Party-Name>" & Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString()) & "</Party-Name>" & vbCrLf

        Forwarder = Forwarder & "<Party-Address>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("endereco")) = True, "", ltempDT.Rows(0)("endereco").ToString())) & "</Party-Address>" & vbCrLf

        Forwarder = Forwarder & "<Party-City>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cidade")) = True, "", ltempDT.Rows(0)("cidade").ToString())) & "</Party-City>" & vbCrLf

        Forwarder = Forwarder & "<Party-State-Prov>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("uf")) = True, "", ltempDT.Rows(0)("uf").ToString())) & "</Party-State-Prov>" & vbCrLf

        Forwarder = Forwarder & "<Party-PostalCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cep")) = True, "", ltempDT.Rows(0)("cep").ToString())) & "</Party-PostalCode>" & vbCrLf

        Forwarder = Forwarder & "<Party-Country>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cd_pais")) = True, "", ltempDT.Rows(0)("cd_pais").ToString())) & "</Party-Country>" & vbCrLf
        Forwarder = Forwarder & "<PartyLocation-ID>" + ltempDT.Rows(0)("codigo").ToString() + "</PartyLocation-ID>" + vbCrLf

        Forwarder = Forwarder & CSR_Contact()
        Forwarder = Forwarder & CSR_Manager()
        'Forwarder = Forwarder + "<Party-GlobalCode>" + RsTemp!codigo + "</Party-GlobalCode>" + vbCrLf
        Forwarder = Forwarder & "<Party-CountryName>" + ltempDT.Rows(0)("Pais").ToString() + "</Party-CountryName>" + vbCrLf

        Forwarder = Forwarder & "<Party-UnlocCode>" + ltempDT.Rows(0)("cd_pais").ToString() + Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("SCAC")) = True, "", ltempDT.Rows(0)("SCAC").ToString())) + "</Party-UnlocCode>"

        If IsDBNull(ltempDT.Rows(0)("cnpj").ToString()) = False Then
            Forwarder = Forwarder & "<GovIDNumber>" & Replace(ltempDT.Rows(0)("cnpj").ToString(), " ", "") & "</GovIDNumber>" & vbCrLf
        End If
        Forwarder = Forwarder & "</Parties>"

    End Function
    Private Function ACASVerifica() As Boolean

        Dim ltempDT As New Data.DataTable

        StrSql = "spIntPessoa_Sel '" & ProcessoDT.Rows(0)("cd_consig").ToString() & "' " '"

        'Verifica pais do Consignee
        ACASVerifica = True
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("cd_pais")) = True Then
                ACASVerifica = False
                Exit Function
            End If
            If Trim(ltempDT.Rows(0)("cd_pais")) = "" Then
                ACASVerifica = False
                Exit Function
            End If


        End If



    End Function
    Private Function GlobalAgent() As String

        Dim ltempDT As New Data.DataTable

        If Mid(ProcessoDT.Rows(0)("processo").ToString(), 2, 1) = "O" Then Exit Function
        GlobalAgent = ""
        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EA"
                StrSql = "select cd_consig_mea cd_agente,cd_export_mea cd_forwarder from master_exp_aer with(nolock) where num_proc_mea='" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
            Case "EM"
                StrSql = "select cd_consig_mem cd_agente,cd_export_mem cd_forwarder from master_exp_mar with(nolock)  where num_proc_mem='" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
            Case "IM"
                StrSql = "select cd_export_mim Cd_agente,cd_export_mim cd_forwarder from master_imp_mar with(nolock)  where num_proc_mim='" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
            Case "IA"
                StrSql = "select cd_export_mia cd_agente, cd_export_mia cd_forwarder from master_imp_aer with(nolock)  where num_proc_mia='" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
            Case "EO"
                StrSql = "select cd_consig_mea cd_agente,cd_export_mea cd_forwarder from master_exp_aer with(nolock)  where num_proc_mea='" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
            Case "IO"
                StrSql = "select cd_export_mim cd_pes from master_imp_mar with(nolock) where num_proc_mim='" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        If ltempDT.Rows.Count > 1 And IsDBNull(ltempDT.Rows(0)("cd_agente")) = False Then
            If ProcessoDT.Rows(0)("num_master").ToString() <> "JOB" Then
                GlobalAgent = Pessoa("GlobalAgent", ltempDT.Rows(0)("cd_agente").ToString())
            End If

            ' GlobalAgent = GlobalAgent + Pessoa("Forwarder", RsTemp!cd_forwarder)

        End If

    End Function
    Private Function Process_Instruction() As String

        Process_Instruction = "<ProcessingInstructions>" & vbCrLf

        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1))
            Case "E"
                Select Case StrPais
                    Case "Argentina"
                        Process_Instruction = Process_Instruction & "<Process>BRTP</Process>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<Status/>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<SystemCode Code ='BRTP'></SystemCode>" & vbCrLf
                    Case "Brasil"
                        Process_Instruction = Process_Instruction & "<Process>BRTP</Process>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<Status/>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<SystemCode Code ='BRTP'></SystemCode>" & vbCrLf
                    Case "Chile"
                        Process_Instruction = Process_Instruction & "<Process>CLTP</Process>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<Status/>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<SystemCode Code ='CLTP'></SystemCode>" & vbCrLf
                End Select

            Case "I"
                Select Case StrPais
                    Case "Argentina"
                        Process_Instruction = Process_Instruction & "<Process>ARIM</Process>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<Status/>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<SystemCode Code ='ARIM'></SystemCode>" & vbCrLf
                    Case "Brasil"
                        Process_Instruction = Process_Instruction & "<Process>BRIM</Process>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<Status/>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<SystemCode Code ='BRIM'></SystemCode>" & vbCrLf
                    Case "Chile"
                        Process_Instruction = Process_Instruction & "<Process>CLIM</Process>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<Status/>" & vbCrLf
                        Process_Instruction = Process_Instruction & "<SystemCode Code ='CLIM'></SystemCode>" & vbCrLf
                End Select
        End Select
        Process_Instruction = Process_Instruction & "<GlobalHubRoutingCode>SHIPMENT</GlobalHubRoutingCode>" & vbCrLf
        Process_Instruction = Process_Instruction & "</ProcessingInstructions>"

    End Function
    Private Function BDPJobNumber() As String

        '    If Left(RsProcesso!processo, 1) = "I" Then
        '        MsgBox "teste"
        '    End If
        '

        BDPJobNumber = "<References type= 'BDPJobNumber'>" & vbCrLf
        BDPJobNumber = CStr(BDPJobNumber & "<ReferenceNumber>" + ProcessoDT.Rows(0)("processo").ToString() + "</ReferenceNumber>" + vbCrLf)
        BDPJobNumber = BDPJobNumber & "</References>"

        If strConsol = "Y" Then
            BDPJobNumber = "<References type= 'BDPJobNumber'>" & vbCrLf
            BDPJobNumber = CStr(BDPJobNumber & "<ReferenceNumber>" + ProcessoDT.Rows(0)("num_master").ToString() + "</ReferenceNumber>" + vbCrLf)
            BDPJobNumber = BDPJobNumber & "</References>"
        End If

    End Function

    Private Function ImprtLicNeededInd() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spSmartNecessidadeLI_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ImprtLicNeededInd = ""

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) <> "I" Then
            ImprtLicNeededInd = ""
            Exit Function

        End If
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then Exit Function


        If IsDBNull(ltempDT.Rows(0)("campo")) = True Then Exit Function

        ImprtLicNeededInd = "<References type= 'ImprtLicNeededInd'>" & vbCrLf

        ImprtLicNeededInd = ImprtLicNeededInd & "<ReferenceNumber>" & IIf(IsDBNull(ltempDT.Rows(0)("campo")) = True, "", ltempDT.Rows(0)("campo").ToString()) & "</ReferenceNumber>" & vbCrLf
        ImprtLicNeededInd = ImprtLicNeededInd & "</References>"


    End Function

    Private Function SellerCode() As String

        SellerCode = "<References type= 'SellerCode'>" & vbCrLf
        SellerCode = SellerCode & "<ReferenceNumber>" + ProcessoDT.Rows(0)("cd_Export").ToString() + "</ReferenceNumber>" + vbCrLf
        SellerCode = SellerCode & "</References>"

    End Function

    Private Function CustomerCSRName() As String

        CustomerCSRName = "<References type= 'CustomerCSRName'>" & vbCrLf
        CustomerCSRName = SellerCode() & "<ReferenceNumber>" + ProcessoDT.Rows(0)("cd_Export").ToString() + "</ReferenceNumber>" + vbCrLf
        CustomerCSRName = SellerCode() & "</References>"

    End Function

    Private Function Shipment() As String
        Dim ltempDT As New Data.DataTable


        If StrType = "301" Then
            Shipment = "<References type= 'ShipmentNumber'>" & vbCrLf
            Shipment = Shipment & "<ReferenceNumber>" & strLevisISD & "</ReferenceNumber>" & vbCrLf
            Shipment = Shipment & "</References>"
            Exit Function

        End If

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select numero_po_him Numero from po_him with(nolock) where num_proc_him='" & strProcesso & "' and id_dc=8"
            Case "IA"
                StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and id_dc=8"
            Case "EA"
                StrSql = "select numERO_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and id_dc=8"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and id_dc=8"
            Case "IO"
                StrSql = "select numero_po_hIO Numero from po_hIO with(nolock) where num_proc_hIO='" & strProcesso & "' and id_dc=8"
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and id_dc=8"
        End Select
        'If StrType = "301" Then
        '    StrSql = "select top 1 PD.Num_Pedido Numero from pedido_ship PS join Pedido PD on PS.cd_pedido= PD.cd_pedido where num_proc='" & strProcesso & "'"
        'End If
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Shipment = "<References type= 'ShipmentNumber'>" & vbCrLf
        If ltempDT.Rows.Count > 0 Then
            Shipment = Shipment & "<ReferenceNumber>" + ltempDT.Rows(0)("numero").ToString() + "</ReferenceNumber>" + vbCrLf
        Else

            Shipment = Shipment & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True, "", ProcessoDT.Rows(0)("HAWB").ToString()) & "</ReferenceNumber>" & vbCrLf
        End If
        Shipment = Shipment & "</References>"

    End Function

    Private Function SAPShipment() As String
        Dim ltempDT As New Data.DataTable


        If StrType = "301" Then
            SAPShipment = "<References type= 'SAPShipmentNumber'>" & vbCrLf
            SAPShipment = SAPShipment & "<ReferenceNumber>" & strLevisISD & "</ReferenceNumber>" & vbCrLf
            SAPShipment = SAPShipment & "</References>"
            Exit Function

        End If

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select numero_po_him Numero from po_him with(nolock) where num_proc_him='" & strProcesso & "' and id_dc=8"
            Case "IA"
                StrSql = "select numero_po_hiA Numero from po_hiA with(nolock) where num_proc_hiA='" & strProcesso & "' and id_dc=8"
            Case "EA"
                StrSql = "select numERO_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and id_dc=8"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and id_dc=8"
            Case "IO"
                StrSql = "select numero_po_hIO Numero from po_hIO with(nolock) where num_proc_hIO='" & strProcesso & "' and id_dc=8"
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and id_dc=8"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        SAPShipment = "<References type= 'SAPShipmentNumber'>" & vbCrLf
        If ltempDT.Rows.Count > 0 Then
            SAPShipment = SAPShipment & "<ReferenceNumber>" + ltempDT.Rows(0)("numero").ToString() + "</ReferenceNumber>" + vbCrLf
        Else

            SAPShipment = SAPShipment & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True, "", ProcessoDT.Rows(0)("HAWB").ToString()) & "</ReferenceNumber>" & vbCrLf
        End If
        SAPShipment = SAPShipment & "</References>"

    End Function

    Private Function CSR_Contact() As String


        Dim ltempDT As New Data.DataTable
        CSR_Contact = ""
        StrSql = "spCSRJob_SEL '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            CSR_Contact = CSR_Contact & "<Party-Contacts Action='Add' type=""CSR"">" & vbCrLf
            CSR_Contact = CSR_Contact & "<Contact-Name>" & Upper_Case(ltempDT.Rows(0)("nome_usuario").ToString()) & "</Contact-Name>" & vbCrLf
            CSR_Contact = CSR_Contact & "<Contact-CommunicationAddress type=""Email""><![CDATA[" + ltempDT.Rows(0)("Email").ToString() + "]]></Contact-CommunicationAddress>" + vbCrLf
            CSR_Contact = CSR_Contact & "</Party-Contacts>"
        End If


    End Function

    Private Function PO() As String

        Dim ltempDT As New Data.DataTable
        Dim StrPO As String

        StrPO = ""

        If StrPO = "" Then
            Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
                Case "IM"
                    StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & strProcesso & "' and (id_dc=1) and numero_po_him <> 'Contract#:00000000' order by id_dc desc"
                Case "IA"
                    StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and (id_dc=1) and numero_po_hia <> 'Contract#:00000000' order by id_dc desc"
                Case "EA"
                    StrSql = "select numERO_po_hEA Numero from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and (id_dc=1) and numero_po_hea <> 'Contract#:00000000' order by id_dc desc"
                Case "EM"
                    StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and (id_dc=1) and numero_po_hem <> 'Contract#:00000000' order by id_dc desc"
                Case "IO"
                    StrSql = "select numero_po_hIO Numero from po_hIO with(nolock) where num_proc_hIO='" & strProcesso & "' and (id_dc=1) and  numero_po_hio <> 'Contract#:00000000' order by id_dc desc"
                Case "EO"
                    StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and (id_dc=1)   and numero_po_heo <> 'Contract#:00000000' order by id_dc desc"
            End Select
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then

                StrPO = IIf(IsDBNull(ltempDT.Rows(0)("numero")) = True, "", (ltempDT.Rows(0)("numero")).ToString())
            Else
                StrPO = ""
            End If
        End If
        StrPO = Upper_Case(StrPO)
        PO = "<References type= 'PurchaseOrderNumber'>" & vbCrLf
        PO = PO & "<ReferenceNumber>" & StrPO & "</ReferenceNumber>" & vbCrLf
        PO = PO & "</References>"

        If StrPO = "" Then PO = ""


    End Function

    Private Function BuyerReferenceNumber() As String

        Dim ltempDT As New Data.DataTable
        Dim StrPO As String

        StrPO = ""


        If strLayout = "Levis" Or StrType = "301" Then
            StrPO = Upper_Case(StrPO)
            BuyerReferenceNumber = "<References type= 'BuyerReferenceNumber'>" & vbCrLf
            BuyerReferenceNumber = BuyerReferenceNumber & "<ReferenceNumber>" & strLevisISD & "</ReferenceNumber>" & vbCrLf
            BuyerReferenceNumber = BuyerReferenceNumber & "</References>"
            Exit Function

        End If
        If StrPO = "" Then
            Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
                Case "IM"
                    StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & strProcesso & "' and (id_dc=9 or id_dc=1) and numero_po_him <> 'Contract#:00000000' order by id_dc desc"
                Case "IA"
                    StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and (id_dc=9 or id_dc=1) and numero_po_hia <> 'Contract#:00000000' order by id_dc desc"
                Case "EA"
                    StrSql = "select numERO_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and (id_dc=9 or id_dc=1) and numero_po_hea <> 'Contract#:00000000' order by id_dc desc"
                Case "EM"
                    StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and (id_dc=9 or id_dc=1) and numero_po_hem <> 'Contract#:00000000' order by id_dc desc"
                Case "IO"
                    StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & strProcesso & "' and (id_dc=9 or id_dc=1) and (id_dc=9 or id_dc=1) and numero_po_hio <> 'Contract#:00000000' order by id_dc desc"
                Case "EO"
                    StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and (id_dc=9 or id_dc=1) and (id_dc=9 or id_dc=1) and numero_po_heo <> 'Contract#:00000000' order by id_dc desc"
            End Select
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then

                StrPO = IIf(IsDBNull(ltempDT.Rows(0)("numero")) = True, "", (ltempDT.Rows(0)("numero")).ToString())
            Else
                StrPO = ""
            End If
        End If
        StrPO = Upper_Case(StrPO)
        BuyerReferenceNumber = "<References type= 'BuyerReferenceNumber'>" & vbCrLf
        BuyerReferenceNumber = BuyerReferenceNumber & "<ReferenceNumber>" & StrPO & "</ReferenceNumber>" & vbCrLf
        BuyerReferenceNumber = BuyerReferenceNumber & "</References>"

        If BuyerReferenceNumber = "" Then BuyerReferenceNumber = ""


    End Function

    Private Function Order() As String

        Dim ltempDT As New Data.DataTable


        'If Mid(strProcesso, 3, 3) = "CSR" Then
        '    StrSql = "spSmartPedidoDow_Sel '" & strProcesso & "'"
        '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        '     If ltempDT.Rows.Count > 0 Then
        '        Order = "<References type= 'SalesOrderNumber'>" & vbCrLf
        '        Order = Order & "<ReferenceNumber>" & Upper_Case(lTempDT.Rows(0)("Num_PO").toString()) & "</ReferenceNumber>" & vbCrLf
        '        Order = Order & "</References>"
        '        Exit Function
        '    End If
        '    RsTemp = Nothing
        'End If

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & strProcesso & "' and id_dc=3"
            Case "IA"
                StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and id_dc=3"
            Case "EA"
                StrSql = "select numERO_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and id_dc=3"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and id_dc=3"
            Case "IO"
                StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & strProcesso & "' and id_dc=3"
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and id_dc=3"
        End Select
        If StrType = "301" Then
            StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and id_dc=8"
        End If
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Order = "<References type= 'SalesOrderNumber'>" & vbCrLf
        If ltempDT.Rows.Count > 0 Then
            Order = Order & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("numero").ToString()) & "</ReferenceNumber>" & vbCrLf
        Else

            Order = CStr(CDbl(Order & "<ReferenceNumber>") + IIf(IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True, "", Upper_Case(ProcessoDT.Rows(0)("HAWB").ToString())) + CDbl("</ReferenceNumber>") + CDbl(vbCrLf))
        End If
        Order = Order & "</References>"


    End Function

    Private Function OrderType(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spSmartIntOrderType_Sel '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        OrderType = ""
        If ltempDT.Rows.Count = 0 Then Exit Function


        OrderType = "<References type= 'OrderType'>" & vbCrLf
        OrderType = OrderType & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("saida").ToString()) & "</ReferenceNumber>" & vbCrLf
        OrderType = OrderType & "</References>"


    End Function

    Private Function DeliveryOrderNumber(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable
        Dim StrTemp As String
        StrSql = "spSmartIntDeliveryOrderNumber_Sel '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        DeliveryOrderNumber = ""
        If ltempDT.Rows.Count = 0 Then Exit Function

        StrTemp = ltempDT.Rows(0)("LOTE").ToString()


        For Each lTempDR As DataRow In ltempDT.Rows
            StrTemp = lTempDR.Item("LOTE").ToString() + "-" + StrTemp

        Next



        DeliveryOrderNumber = "<References type= 'DeliveryOrderNumber'>" & vbCrLf
        DeliveryOrderNumber = DeliveryOrderNumber & "<ReferenceNumber>" & Upper_Case(StrTemp) & "</ReferenceNumber>" & vbCrLf
        DeliveryOrderNumber = DeliveryOrderNumber & "</References>"


    End Function

    Private Function Invoices_RD_IK(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable

        Invoices_RD_IK = ""

        StrSql = "spPO_Sel '" & strProcesso & "',33"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Invoices_RD_IK = " - RD " + ltempDT.Rows(0)("Num_Doc").ToString()
        End If


        StrSql = "spPO_Sel '" & strProcesso & "',34"
        ltempDT = New DataTable()
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Invoices_RD_IK = Invoices_RD_IK & " - IK " + ltempDT.Rows(0)("Num_Doc").ToString()
        End If




    End Function

    Private Function Invoice_Number() As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select numero_po_him Numero from po_him with(nolock) where num_proc_him='" & strProcesso & "' and id_dc=2"
            Case "IA"
                StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and id_dc=2"
            Case "EA"
                StrSql = "select numero_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and id_dc=2"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and id_dc=2"
            Case "IO"
                StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & strProcesso & "' and id_dc=2"
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and id_dc=2"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            Invoice_Number = ""
        Else

            If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
                Invoice_Number = ""
            Else
                Invoice_Number = "<References type= 'InvoiceNumber'>" & vbCrLf
                Invoice_Number = Invoice_Number & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("numero").ToString()) & "</ReferenceNumber>" & vbCrLf
                Invoice_Number = Invoice_Number & "</References>"
            End If
        End If

        If Invoice_Number = "" Then
            StrErro = StrErro & " - " & "Invoice n�o informada"
        End If

    End Function

    Private Function Invoice_STR() As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & strProcesso & "' and id_dc=2"
            Case "IA"
                StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and id_dc=2"
            Case "EA"
                StrSql = "select numero_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and id_dc=2"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and id_dc=2"
            Case "IO"
                StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & strProcesso & "' and id_dc=2"
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and id_dc=2"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            Invoice_STR = ""
        Else

            If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
                Invoice_STR = ""
            Else
                Invoice_STR = Upper_Case(ltempDT.Rows(0)("numero").ToString())
            End If
        End If

        If Invoice_Number() = "" Then
            StrErro = StrErro & " - " & "Invoice n�o informada"
        End If

    End Function

    'Private Function Data_DI() As String

    '    Dim ltempDT As New Data.DataTable

    '    If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then Exit Function

    '    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
    '        Case "IM"
    '            StrSql = "select Data_PO_HIM Data_DI  from po_him with(nolock)  where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "IA"
    '            StrSql = "select Data_PO_HIA Data_DI from po_hiA with(nolock)  where num_proc_hiA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EA"
    '            StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "EM"
    '            StrSql = "select Data_PO_HEM Data_DI  from po_hEM with(nolock)  where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "IO"
    '            StrSql = "select Data_PO_HIO Data_DI  from po_hIO with(nolock)  where num_proc_hIO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EO"
    '            StrSql = "select Data_PO_HEO Data_DI  from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '    Data_DI = ""
    '    If ltempDT.Rows.Count > 0 Then
    '        Data_DI = "<Status>" & vbCrLf
    '        Data_DI = Data_DI & "<StatusType type='EntrySummarySubmitDate'/>" & vbCrLf

    '        Data_DI = Data_DI & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data_DI")) = True, "", ltempDT.Rows(0)("Data_DI").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '        Data_DI = Data_DI & "</Status>"
    '    End If

    'End Function
    Private Function Data_DI() As String

        Dim ltempDT As New Data.DataTable
        Dim strProcesso As String = ProcessoDT.Rows(0)("processo").ToString()
        Dim dtDI As String = ""

        Data_DI = ""

        If VB.Left(strProcesso, 1) = "E" Then Exit Function

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM", "IA", "IO"
                StrSql = "spIntDIDUIMP_Date_Sel '" & strProcesso & "'"

            Case "EA"
                StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and id_dc=4"

            Case "EM"
                StrSql = "select Data_PO_HEM Data_DI from po_hEM with(nolock) where num_proc_hEM='" & strProcesso & "' and id_dc=4"

            Case "EO"
                StrSql = "select Data_PO_HEO Data_DI from po_hEO with(nolock) where num_proc_hEO='" & strProcesso & "' and id_dc=4"

            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 AndAlso Not IsDBNull(ltempDT.Rows(0)("Data_DI")) Then
            dtDI = VB6.Format(ltempDT.Rows(0)("Data_DI"), "yyyymmdd")

            Data_DI = "<Status>" & vbCrLf
            Data_DI = Data_DI & "<StatusType type='EntrySummarySubmitDate'/>" & vbCrLf
            Data_DI = Data_DI & "<StatusDate>" & dtDI & "</StatusDate>" & vbCrLf
            Data_DI = Data_DI & "</Status>"
        End If

    End Function

    'Private Function CustomsEntryPermitSubmissionDate() As String

    '    Dim ltempDT As New Data.DataTable

    '    CustomsEntryPermitSubmissionDate = ""

    '    '    If Left(RsProcesso, 1) = "E" Then Exit Function

    '    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
    '        Case "IM"
    '            StrSql = "select Data_PO_HIM Data_DI  from po_him with(nolock)  where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "IA"
    '            StrSql = "select Data_PO_HIA Data_DI from po_hiA with(nolock)  where num_proc_hiA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EA"
    '            StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "EM"
    '            StrSql = "select Data_PO_HEM Data_DI  from po_hEM with(nolock)  where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "IO"
    '            StrSql = "select Data_PO_HIO Data_DI  from po_hIO with(nolock)  where num_proc_hIO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EO"
    '            StrSql = "select Data_PO_HEO Data_DI  from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)



    '    If ltempDT.Rows.Count > 0 Then
    '        CustomsEntryPermitSubmissionDate = "<Status>" & vbCrLf
    '        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then
    '            CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "<StatusType type='GovernmentPermissionToExportSubmissionDate'/>" & vbCrLf
    '        Else
    '            CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "<StatusType type='CustomsEntryPermitSubmissionDate'/>" & vbCrLf
    '        End If

    '        CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data_DI")) = True, "", ltempDT.Rows(0)("Data_DI").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '        CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "</Status>"
    '    End If

    'End Function
    Private Function CustomsEntryPermitSubmissionDate() As String

        Dim ltempDT As New Data.DataTable
        Dim strProcesso As String = ProcessoDT.Rows(0)("processo").ToString()
        Dim dtDI As String = ""

        CustomsEntryPermitSubmissionDate = ""

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM", "IA", "IO"
                StrSql = "spIntDIDUIMP_Date_Sel '" & strProcesso & "'"

            Case "EA"
                StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and id_dc=4"

            Case "EM"
                StrSql = "select Data_PO_HEM Data_DI from po_hEM with(nolock) where num_proc_hEM='" & strProcesso & "' and id_dc=4"

            Case "EO"
                StrSql = "select Data_PO_HEO Data_DI from po_hEO with(nolock) where num_proc_hEO='" & strProcesso & "' and id_dc=4"

            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 AndAlso Not IsDBNull(ltempDT.Rows(0)("Data_DI")) Then
            dtDI = VB6.Format(ltempDT.Rows(0)("Data_DI"), "yyyymmdd")

            CustomsEntryPermitSubmissionDate = "<Status>" & vbCrLf

            If VB.Left(strProcesso, 1) = "E" Then
                CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "<StatusType type='GovernmentPermissionToExportSubmissionDate'/>" & vbCrLf
            Else
                CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "<StatusType type='CustomsEntryPermitSubmissionDate'/>" & vbCrLf
            End If

            CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "<StatusDate>" & dtDI & "</StatusDate>" & vbCrLf
            CustomsEntryPermitSubmissionDate = CustomsEntryPermitSubmissionDate & "</Status>"
        End If

    End Function

    'Private Function LiquidationDate() As String

    '    Dim ltempDT As New Data.DataTable


    '    LiquidationDate = ""
    '    If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then Exit Function

    '    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
    '        Case "IM"
    '            StrSql = "select Data_PO_HIM Data_DI  from po_him with(nolock) where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "IA"
    '            StrSql = "select Data_PO_HIA Data_DI from po_hiA with(nolock)  where num_proc_hiA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EA"
    '            StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "EM"
    '            StrSql = "select Data_PO_HEM Data_DI  from po_hEM with(nolock)  where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "IO"
    '            StrSql = "select Data_PO_HIO Data_DI  from po_hIO with(nolock)  where num_proc_hIO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EO"
    '            StrSql = "select Data_PO_HEO Data_DI  from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '    LiquidationDate = ""
    '    If ltempDT.Rows.Count > 0 Then
    '        LiquidationDate = "<Status>" & vbCrLf
    '        LiquidationDate = LiquidationDate & "<StatusType type='LiquidationDate'/>" & vbCrLf

    '        LiquidationDate = LiquidationDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data_DI")) = True, "", ltempDT.Rows(0)("Data_DI").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '        LiquidationDate = LiquidationDate & "</Status>"
    '    End If

    'End Function
    Private Function LiquidationDate() As String

        Dim ltempDT As New Data.DataTable
        Dim strProcesso As String = ProcessoDT.Rows(0)("processo").ToString()

        LiquidationDate = ""

        If VB.Left(strProcesso, 1) = "E" Then Exit Function

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM", "IA", "IO"
                StrSql = "spIntDIDUIMP_Date_Sel '" & strProcesso & "'"

            Case "EA"
                StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and id_dc=4"

            Case "EM"
                StrSql = "select Data_PO_HEM Data_DI from po_hEM with(nolock) where num_proc_hEM='" & strProcesso & "' and id_dc=4"

            Case "EO"
                StrSql = "select Data_PO_HEO Data_DI from po_hEO with(nolock) where num_proc_hEO='" & strProcesso & "' and id_dc=4"

            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If Not IsDBNull(ltempDT.Rows(0)("Data_DI")) Then
                LiquidationDate = "<Status>" & vbCrLf
                LiquidationDate = LiquidationDate & "<StatusType type='LiquidationDate'/>" & vbCrLf
                LiquidationDate = LiquidationDate & "<StatusDate>" & VB6.Format(ltempDT.Rows(0)("Data_DI"), "yyyymmdd") & "</StatusDate>" & vbCrLf
                LiquidationDate = LiquidationDate & "</Status>"
            End If
        End If

    End Function

    'Private Function GovernmentPaymentStatementPaymentDate() As String

    '    Dim ltempDT As New Data.DataTable


    '    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
    '        Case "IM"
    '            StrSql = "select Data_PO_HIM Data_DI  from po_him with(nolock)  where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "IA"
    '            StrSql = "select Data_PO_HIA Data_DI from po_hiA with(nolock)  where num_proc_hiA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EA"
    '            StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "EM"
    '            StrSql = "select Data_PO_HEM Data_DI  from po_hEM with(nolock) where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "IO"
    '            StrSql = "select Data_PO_HIO Data_DI  from po_hIO with(nolock)  where num_proc_hIO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EO"
    '            StrSql = "select Data_PO_HEO Data_DI  from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '    GovernmentPaymentStatementPaymentDate = ""
    '    If ltempDT.Rows.Count > 0 Then
    '        GovernmentPaymentStatementPaymentDate = "<Status>" & vbCrLf
    '        GovernmentPaymentStatementPaymentDate = GovernmentPaymentStatementPaymentDate & "<StatusType type='GovernmentPaymentStatementSubmissionDate'/>" & vbCrLf

    '        GovernmentPaymentStatementPaymentDate = GovernmentPaymentStatementPaymentDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data_DI")) = True, "", ltempDT.Rows(0)("Data_DI").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '        GovernmentPaymentStatementPaymentDate = GovernmentPaymentStatementPaymentDate & "</Status>"
    '    End If

    'End Function
    Private Function GovernmentPaymentStatementPaymentDate() As String

        Dim ltempDT As New Data.DataTable
        Dim strProcesso As String = ProcessoDT.Rows(0)("processo").ToString()

        GovernmentPaymentStatementPaymentDate = ""

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM", "IA", "IO"
                StrSql = "spIntDIDUIMP_Date_Sel '" & strProcesso & "'"

            Case "EA"
                StrSql = "select Data_PO_HEA Data_DI from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and id_dc=4"

            Case "EM"
                StrSql = "select Data_PO_HEM Data_DI from po_hEM with(nolock) where num_proc_hEM='" & strProcesso & "' and id_dc=4"

            Case "EO"
                StrSql = "select Data_PO_HEO Data_DI from po_hEO with(nolock) where num_proc_hEO='" & strProcesso & "' and id_dc=4"

            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If Not IsDBNull(ltempDT.Rows(0)("Data_DI")) Then
                GovernmentPaymentStatementPaymentDate = "<Status>" & vbCrLf
                GovernmentPaymentStatementPaymentDate = GovernmentPaymentStatementPaymentDate & "<StatusType type='GovernmentPaymentStatementSubmissionDate'/>" & vbCrLf
                GovernmentPaymentStatementPaymentDate = GovernmentPaymentStatementPaymentDate & "<StatusDate>" & VB6.Format(ltempDT.Rows(0)("Data_DI"), "yyyymmdd") & "</StatusDate>" & vbCrLf
                GovernmentPaymentStatementPaymentDate = GovernmentPaymentStatementPaymentDate & "</Status>"
            End If
        End If

    End Function

    Private Function OfficeDeOrigem() As String

        OfficeDeOrigem = ""
        If VB.Left(strProcesso, 2) <> "EA" Then Exit Function

        OfficeDeOrigem = "<Parties type='CSR'>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-Name>Sao Paulo Office</Party-Name>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-Address>Rua Geraldo Flausino 78 - Andar</Party-Address>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-City>Sao Paulo</Party-City>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-State-Prov>SP</Party-State-Prov>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-PostalCode>04575060</Party-PostalCode>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-Country>BR</Party-Country>"
        OfficeDeOrigem = OfficeDeOrigem & "<PartyLocation-ID>BDPBRSAO</PartyLocation-ID>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-Contacts Action='Add' type='ACAS'>"
        OfficeDeOrigem = OfficeDeOrigem & "<Contact-Name>Joao Djalma</Contact-Name>"
        OfficeDeOrigem = OfficeDeOrigem & "<Contact-CommunicationAddress type='Email'>joao.djalma@bdpint.com</Contact-CommunicationAddress>"
        OfficeDeOrigem = OfficeDeOrigem & "<Contact-CommunicationAddress type='Telephone'>+55-11-5504-3417</Contact-CommunicationAddress>"
        OfficeDeOrigem = OfficeDeOrigem & "<ContactFirstName>Joao</ContactFirstName>"
        OfficeDeOrigem = OfficeDeOrigem & "<ContactLastName>Djalma</ContactLastName>"
        OfficeDeOrigem = OfficeDeOrigem & "</Party-Contacts>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-CountryName>Brazil</Party-CountryName>"
        OfficeDeOrigem = OfficeDeOrigem & "<Party-UnlocCode>BRSAO</Party-UnlocCode>"
        OfficeDeOrigem = OfficeDeOrigem & "<GovIDNumber>03706460000128</GovIDNumber>"
        OfficeDeOrigem = OfficeDeOrigem & "</Parties>"

    End Function

    'Private Function DI_Number() As String

    '    Dim ltempDT As New Data.DataTable

    '    DI_Number = ""
    '    ' If Left(RsProcesso!processo, 1) = "E" Then Exit Function

    '    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
    '        Case "IM"
    '            StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "IA"
    '            StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EA"
    '            StrSql = "select numero_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "EM"
    '            StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "IO"
    '            StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EO"
    '            StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)

    '    If ltempDT.Rows.Count = 0 Then
    '        DI_Number = ""
    '    Else
    '        'Regra Inserida por Erbson 19/08/2015 - N�o utilizar par ao 301
    '        If (StrType.Equals("301") = False) Then
    '            If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
    '                DI_Number = ""
    '            Else
    '                DI_Number = "<References type= 'EntryNumber'>" & vbCrLf
    '                DI_Number = DI_Number & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("numero").ToString()) & "</ReferenceNumber>" & vbCrLf
    '                DI_Number = DI_Number & "</References>"
    '            End If
    '        End If
    '    End If
    '    If DI_Number = "" Then
    '        StrErro = StrErro & " - " & "Invoice n�o informada"
    '    End If

    'End Function
    Private Function DI_Number() As String

        Dim ltempDT As New Data.DataTable
        Dim strProcesso As String = ProcessoDT.Rows(0)("processo").ToString()

        DI_Number = ""

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM", "IA", "IO"
                StrSql = "spIntDIDUIMP_Number_Sel '" & strProcesso & "'"

            Case "EA"
                StrSql = "select numero_po_hEA Numero from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and id_dc=4"

            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock) where num_proc_hEM='" & strProcesso & "' and id_dc=4"

            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock) where num_proc_hEO='" & strProcesso & "' and id_dc=4"

            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            DI_Number = ""
        Else
            'Regra Inserida por Erbson 19/08/2015 - Não utilizar para o 301
            If (StrType.Equals("301") = False) Then
                If IsDBNull(ltempDT.Rows(0)("Numero")) = True Then
                    DI_Number = ""
                Else
                    DI_Number = "<References type='EntryNumber'>" & vbCrLf
                    DI_Number = DI_Number & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("Numero").ToString()) & "</ReferenceNumber>" & vbCrLf
                    DI_Number = DI_Number & "</References>"
                End If
            End If
        End If

        If DI_Number = "" Then
            StrErro = StrErro & " - " & "Invoice n o informada"
        End If

    End Function

    Private Function GeneralDescription() As String


        GeneralDescription = ""
        GeneralDescription = GeneralDescription & "<References type = 'GeneralDescription'>" & vbCrLf
        GeneralDescription = GeneralDescription & "<ReferenceNumber> <![CDATA[" & IIf(IsDBNull(ProcessoDT.Rows(0)("obs")) = True, "", ProcessoDT.Rows(0)("obs").ToString()) & "]]></ReferenceNumber>"
        GeneralDescription = GeneralDescription & "</References>"

    End Function

    'Private Function CustomsEntryNumber() As String

    '    Dim ltempDT As New Data.DataTable


    '    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
    '        Case "IM"
    '            StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "IA"
    '            StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EA"
    '            StrSql = "select numero_po_hEA Numero from po_hEA with(nolock) where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "EM"
    '            StrSql = "select numero_po_hEM Numero from po_hEM with(nolock) where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '        Case "IO"
    '            StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=5"
    '        Case "EO"
    '            StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)

    '    If ltempDT.Rows.Count = 0 Then
    '        CustomsEntryNumber = ""
    '    Else

    '        If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
    '            CustomsEntryNumber = ""
    '        Else
    '            CustomsEntryNumber = "<References type= 'CustomsEntryNumber'>" & vbCrLf
    '            CustomsEntryNumber = CustomsEntryNumber & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("numero").ToString()) & "</ReferenceNumber>" & vbCrLf
    '            CustomsEntryNumber = CustomsEntryNumber & "</References>"
    '        End If
    '    End If

    '    If CustomsEntryNumber = "" Then
    '        StrErro = StrErro & " - " & "Invoice n�o informada"
    '    End If

    'End Function
    Private Function CustomsEntryNumber() As String

        Dim ltempDT As New Data.DataTable
        Dim strProcesso As String = ProcessoDT.Rows(0)("processo").ToString()
        Dim strNumero As String = ""

        CustomsEntryNumber = ""

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM", "IA", "IO"
                StrSql = "spIntDIDUIMP_Number_Sel '" & strProcesso & "'"

            Case "EA"
                StrSql = "select numero_po_hEA Numero from po_hEA with(nolock) where num_proc_hEA='" & strProcesso & "' and id_dc=4"

            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock) where num_proc_hEM='" & strProcesso & "' and id_dc=4"

            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock) where num_proc_hEO='" & strProcesso & "' and id_dc=4"

            Case Else
                Exit Function
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 AndAlso Not IsDBNull(ltempDT.Rows(0)("Numero")) Then
            strNumero = ltempDT.Rows(0)("Numero").ToString()
        End If

        If strNumero <> "" Then
            CustomsEntryNumber = "<References type='CustomsEntryNumber'>" & vbCrLf
            CustomsEntryNumber = CustomsEntryNumber & "<ReferenceNumber>" & Upper_Case(strNumero) & "</ReferenceNumber>" & vbCrLf
            CustomsEntryNumber = CustomsEntryNumber & "</References>"
        End If

        If CustomsEntryNumber = "" Then
            StrErro = StrErro & " - " & "Invoice n�o informada"
        End If

    End Function

    Private Function GovernmentPermissionToExportReleaseNumber() As String

        Dim ltempDT As New Data.DataTable


        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=12"
            Case "EA"
                StrSql = "select numero_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=12"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=12"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            GovernmentPermissionToExportReleaseNumber = ""
        Else

            If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
                GovernmentPermissionToExportReleaseNumber = ""
            Else
                GovernmentPermissionToExportReleaseNumber = "<References type= 'GovernmentPermissionToExportReleaseNumber'>" & vbCrLf
                GovernmentPermissionToExportReleaseNumber = GovernmentPermissionToExportReleaseNumber & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("numero").ToString()) & "</ReferenceNumber>" & vbCrLf
                GovernmentPermissionToExportReleaseNumber = GovernmentPermissionToExportReleaseNumber & "</References>"
            End If
        End If

        If GovernmentPermissionToExportReleaseNumber = "" Then
            StrErro = StrErro & " - " & "Invoice n�o informada"
        End If

    End Function

    Private Function GovernmentPermissionToExportSubmissionNumber() As String

        Dim ltempDT As New Data.DataTable


        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EO"
                StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
            Case "EA"
                StrSql = "select numero_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
            Case "EM"
                StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_dc=4"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            GovernmentPermissionToExportSubmissionNumber = ""
        Else

            If IsDBNull(ltempDT.Rows(0)("numero")) = True Then
                GovernmentPermissionToExportSubmissionNumber = ""
            Else
                GovernmentPermissionToExportSubmissionNumber = "<References type= 'GovernmentPermissionToExportSubmissionNumber'>" & vbCrLf
                GovernmentPermissionToExportSubmissionNumber = GovernmentPermissionToExportSubmissionNumber & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("numero").ToString()) & "</ReferenceNumber>" & vbCrLf
                GovernmentPermissionToExportSubmissionNumber = GovernmentPermissionToExportSubmissionNumber & "</References>"
            End If
        End If

        If GovernmentPermissionToExportSubmissionNumber = "" Then
            StrErro = StrErro & " - " & "Invoice n�o informada"
        End If

    End Function

    Private Function ExportForwarderRefNbr() As String

        ExportForwarderRefNbr = "<References type= 'ExportForwarderRefNbr'>" & vbCrLf
        'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then
        'ExportForwarderRefNbr = ExportForwarderRefNbr + "<ReferenceNumber>" + RsProcesso!processo + "</ReferenceNumber>" + vbCrLf
        ' ExportForwarderRefNbr = ExportForwarderRefNbr & "<ReferenceNumber>" + IIf(strTipo = "Original", ProcessoDT.Rows(0)("processo").ToString(), StrPROC) + "</ReferenceNumber>" + vbCrLf
        ' Else
        'ExportForwarderRefNbr = ExportForwarderRefNbr + "<ReferenceNumber>" + RsProcesso!processo + "</ReferenceNumber>" + vbCrLf
        ExportForwarderRefNbr = ExportForwarderRefNbr & "<ReferenceNumber>" + ProcessoDT.Rows(0)("processo").ToString() + "</ReferenceNumber>" + vbCrLf
        ' End If
        ExportForwarderRefNbr = ExportForwarderRefNbr & "</References>"

    End Function

    Private Function ShipmentStatus() As String

        ShipmentStatus = "<References type= 'ShipmentStatus'>" & vbCrLf

        ShipmentStatus = ShipmentStatus & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("Job_Status")) = True, "", ProcessoDT.Rows(0)("Job_Status").ToString()) + "</ReferenceNumber>" + vbCrLf
        ShipmentStatus = ShipmentStatus & "</References>"

    End Function

    Private Function ImportForwarderRefNbr() As String

        ImportForwarderRefNbr = "<References type= 'ImportForwarderRefNbr'>" & vbCrLf


        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "E" Then
            ImportForwarderRefNbr = CStr(ImportForwarderRefNbr & "<ReferenceNumber>" + ProcessoDT.Rows(0)("processo").ToString() + "</ReferenceNumber>") + vbCrLf
        Else
            ImportForwarderRefNbr = ImportForwarderRefNbr & "<ReferenceNumber>" + ProcessoDT.Rows(0)("processo").ToString() + "</ReferenceNumber>" & vbCrLf

        End If
        ImportForwarderRefNbr = ImportForwarderRefNbr & "</References>"

    End Function

    Private Function CourierCD() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select cd_vendor from pessoa_llp with(nolock)  where cd_pes='" & ProcessoDT.Rows(0)("cd_courier").ToString() & "' "
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("Cd_Vendor")) = False Then
                CourierCD = "<ReferenceType type= 'CourierAWBCd'>" & vbCrLf
                CourierCD = CourierCD & "<ReferenceNumber>" + ltempDT.Rows(0)("Cd_Vendor").ToString() + "</ReferenceNumber>" + vbCrLf
                CourierCD = CourierCD & "</ReferenceType>"
                Exit Function
            End If
        End If

        CourierCD = ""

    End Function

    Private Function CourierAWB() As String



        If IsDBNull(ProcessoDT.Rows(0)("courier_number")) = False Then
            CourierAWB = "<ReferenceType type= 'CourierAWBNbr'>" & vbCrLf
            CourierAWB = CourierAWB & "<ReferenceNumber>" + ProcessoDT.Rows(0)("courier_number").ToString() + "</ReferenceNumber>" + vbCrLf
            CourierAWB = CourierAWB & "</ReferenceType>"
            Exit Function
        End If

        CourierAWB = ""

    End Function

    Private Function AWBData() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select cd_vendor from pessoa_llp with(nolock)  where cd_pes='" & ProcessoDT.Rows(0)("cd_courier").ToString() & "' "
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("Cd_Vendor")) = False Then
                AWBData = "<AWBData>" & vbCrLf
                AWBData = AWBData & "<AWBNbr>" + ProcessoDT.Rows(0)("courier_number").ToString() + "</AWBNbr>" + vbCrLf
                AWBData = AWBData & "<AWBCd>" + ltempDT.Rows(0)("cd_vendor").ToString() + "</AWBCd>" + vbCrLf
                AWBData = AWBData & "<AWBDest>" & "</AWBDest>" + vbCrLf
                AWBData = AWBData & "<AWBSent>" & "</AWBSent>" + vbCrLf
                AWBData = AWBData & "<AWBDesc>" & "</AWBDesc>" + vbCrLf
                AWBData = AWBData & "<AWBActArrivalDate>" & "</AWBActArrivalDate>" + vbCrLf
                AWBData = AWBData & "</AWBData>"
                Exit Function
            End If
        End If

        '<AWBData>
        '      <AWBNbr><![CDATA[9291867966]]></AWBNbr> numero do awb
        '      <AWBCd><![CDATA[DHL]]></AWBCd> cd_vendor couriercd
        '      <AWBDest><![CDATA[]]></AWBDest> branco
        '      <AWBSent><![CDATA[]]></AWBSent>branco
        '      <AWBDesc><![CDATA[]]></AWBDesc>branco
        '      <AWBActArrivalDate><![CDATA[20150403]]></AWBActArrivalDate>branco
        '  </AWBData>


        AWBData = ""

    End Function

    Private Function AWBDataBR() As String

        Dim ltempDT As New Data.DataTable
        StrSql = "spSmart_Courier_Sel '" & strProcesso & "' "
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        AWBDataBR = ""
        For Each ltempDR As DataRow In ltempDT.Rows
            AWBDataBR = "<AWBData>" & vbCrLf
            AWBDataBR = AWBDataBR & "<AWBNbr>" + ltempDT.Rows(0)("AWBNbr").ToString() + "</AWBNbr>" + vbCrLf
            AWBDataBR = AWBDataBR & "<AWBCd>" + ltempDT.Rows(0)("AWBCd").ToString() + "</AWBCd>" + vbCrLf
            AWBDataBR = AWBDataBR & "<AWBDest>" & "</AWBDest>" + vbCrLf
            AWBDataBR = AWBDataBR & "<AWBSent>" & "</AWBSent>" + vbCrLf
            AWBDataBR = AWBDataBR & "<AWBDesc>" & "</AWBDesc>" + vbCrLf
            AWBDataBR = AWBDataBR & "<AWBActArrivalDate>" + VB6.Format(ltempDR.Item("AWBActArrivalDate").ToString(), "yyyymmdd") + "</AWBActArrivalDate>" + vbCrLf
            AWBDataBR = AWBDataBR & "</AWBData>"
        Next


    End Function

    Private Function CourierAWBReferences() As String



        If IsDBNull(ProcessoDT.Rows(0)("courier_number")) = False Then
            CourierAWBReferences = "<References type= 'CourierAWBNbr'>" & vbCrLf
            CourierAWBReferences = CourierAWBReferences & "<ReferenceNumber>" + ProcessoDT.Rows(0)("courier_number").ToString() + "</ReferenceNumber>" + vbCrLf
            CourierAWBReferences = CourierAWBReferences & "</References>"
            Exit Function
        End If

        CourierAWBReferences = ""

    End Function


    Private Function CourierDocument() As String

        CourierDocument = ""

        If IsDBNull(ProcessoDT.Rows(0)("courier_number")) = False Then
            CourierDocument = "<Documents>" & vbCrLf
            CourierDocument = CourierDocument & "<DocumentDesc>" & "CourierNumber" & "</DocumentDesc>"
            CourierDocument = CourierDocument & "<DocumentNumber>" + ProcessoDT.Rows(0)("courier_number").ToString() + "</DocumentNumber>" + vbCrLf
            CourierDocument = CourierDocument & "</Documents>"
            Exit Function
        End If


    End Function

    Private Function SellerRef(ByRef StrJob As String, ByRef strProcesso As String, ByRef strTipo As String, ByRef StrTag As String) As String

        Dim ltempDT As New Data.DataTable

        If Mid(strProcesso, 3, 3) = "CSR" Then
            StrSql = "spSmartPedidoDow_Sel '" & strProcesso & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then
                SellerRef = "<References type= '" & StrTag & "'>" & vbCrLf
                SellerRef = SellerRef & "<ReferenceNumber>" & Upper_Case(ltempDT.Rows(0)("Num_PO").ToString().Replace("&", " AND ")) & "</ReferenceNumber>" & vbCrLf
                SellerRef = SellerRef & "<ReferenceDate>" & VB6.Format(ltempDT.Rows(0)("dt_pedido").ToString(), "yyyymmdd") & "</ReferenceDate>" & vbCrLf
                SellerRef = SellerRef & "</References>"
                Exit Function
            End If

        End If

        'NG
        'Order number Imports must take 001-PO reference
        Dim RefCod = ""
        If StrPais = "Argentina" And StrTag = "OrderNumber" Then
            Select Case UCase(VB.Left(strProcesso, 1))
                Case "I"
                    RefCod = 1
                Case "E"
                    RefCod = 3
            End Select
        Else
            RefCod = 3
        End If


        Select Case UCase(VB.Left(strProcesso, 2))
            Case "EM"
                StrSql = "select numero_po_hem numero_po from po_hem with(nolock)  where num_proc_hem='" & strProcesso & "' and id_dc='" & RefCod & "'"
            Case "EA"
                StrSql = "select numero_po_hea numero_po from po_hea with(nolock)  where num_proc_hea='" & strProcesso & "' and id_dc='" & RefCod & "'"
            Case "IA"
                StrSql = "select numero_po_hia numero_po from po_hia with(nolock)  where num_proc_hia='" & strProcesso & "' and id_dc='" & RefCod & "'"
            Case "IO"
                StrSql = "select numero_po_hio numero_po from po_hio with(nolock)  where num_proc_hio='" & strProcesso & "' and id_dc='" & RefCod & "'"
            Case "IM"
                StrSql = "select numero_po_him numero_po from po_him with(nolock)  where num_proc_him='" & strProcesso & "' and id_dc='" & RefCod & "'"
            Case "EO"
                StrSql = "select numero_po_heo numero_po from po_heo with(nolock)  where num_proc_heo='" & strProcesso & "' and id_dc='" & RefCod & "'"
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            SellerRef = ""
        Else

            If IsDBNull(ltempDT.Rows(0)("numero_po")) = True Then
                SellerRef = ""
            Else
                SellerRef = "<References type= '" & StrTag & "'>" & vbCrLf
                SellerRef = SellerRef & "<ReferenceNumber>" & IIf(Sales_Diferentes() <> "", Sales_Diferentes() & Invoices_RD_IK(strProcesso), ltempDT.Rows(0)("numero_po").ToString() + Invoices_RD_IK(strProcesso)) & "</ReferenceNumber>" & vbCrLf
                If strTipo = "A" Then
                    SellerRef = SellerRef & "<ReferenceDate>" & VB6.Format(ProcessoDT.Rows(0)("dt_emis").ToString(), "yyyymmdd") & "</ReferenceDate>" & vbCrLf
                End If
                SellerRef = SellerRef & "</References>"
            End If
        End If


    End Function

    Private Function BookingNumber() As String


        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Then Exit Function
        BookingNumber = ""
        BookingNumber = "<References type= 'HouseBookingNumber'>" & vbCrLf
        If UCase(ProcessoDT.Rows(0)("num_master").ToString()) = "JOB" Then

            BookingNumber = BookingNumber & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("nr_reserva")) = True, "", UCase(ProcessoDT.Rows(0)("nr_reserva").ToString())) + "</ReferenceNumber>" + vbCrLf
        Else

            BookingNumber = BookingNumber & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("processo")) = True, "", ProcessoDT.Rows(0)("processo").ToString()) + "</ReferenceNumber>" + vbCrLf
        End If
        BookingNumber = BookingNumber & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        BookingNumber = BookingNumber & "</References>"


    End Function

    Private Function DeadLine_VGM() As String

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "EM" Then Exit Function

        DeadLine_VGM = ""
        'DeadLine_VGM = "<References type= 'SolasVrfdGrMassCutDt'>" & vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("DL_VGM")) = True, "", Convert.ToDateTime(ProcessoDT.Rows(0)("DL_VGM").toString()).ToString("yyyyMMdd")) + "</ReferenceNumber>" + vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("DL_VGM")) = True, "", Convert.ToDateTime(ProcessoDT.Rows(0)("DL_VGM").toString()).ToString("yyyyMMdd")) + "</ReferenceNumber>" + vbCrLf
        ''DeadLine_VGM = DeadLine_VGM & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "</References>"

        'DeadLine_VGM = DeadLine_VGM & "<Status>" & vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "<StatusType type='" & "SolasVrfdGrMassCutDt " & "'/>" & vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "<StatusDate>" & Convert.ToDateTime(ProcessoDT.Rows(0)("DL_VGM").toString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "<StatusTime>" & Convert.ToDateTime(ProcessoDT.Rows(0)("DL_VGM").toString()).ToString("HHmm") & "</StatusTime>" & vbCrLf
        'DeadLine_VGM = DeadLine_VGM & "</Status>" & vbCrLf

        'cadu: 19/07/2016

        If (IsDBNull(ProcessoDT.Rows(0)("DL_VGM")) = False) Then
            DeadLine_VGM = DeadLine_VGM & "<Status>" & vbCrLf
            DeadLine_VGM = DeadLine_VGM & "<StatusType type='" & "SolasVrfdGrMassCutDt" & "'/>" & vbCrLf
            DeadLine_VGM = DeadLine_VGM & "<StatusDate>" & Convert.ToDateTime(ProcessoDT.Rows(0)("DL_VGM").ToString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
            DeadLine_VGM = DeadLine_VGM & "<StatusTime>" & Convert.ToDateTime(ProcessoDT.Rows(0)("DL_VGM").ToString()).ToString("HHmm") & "</StatusTime>" & vbCrLf
            DeadLine_VGM = DeadLine_VGM & "</Status>" & vbCrLf
        End If

    End Function

    Private Function DeadLine_Draft() As String

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "EM" Then Exit Function

        DeadLine_Draft = ""
        Dim dl_draft As String
        If (IsDBNull(ProcessoDT.Rows(0)("DL_Draft")) = False) Then

            If StrType = "301" Then
                dl_draft = ConvertTimeZone(ProcessoDT.Rows(0)("DL_Draft").ToString().ToString, "Eastern Standard Time")
            Else
                dl_draft = ProcessoDT.Rows(0)("DL_Draft").ToString().ToString
            End If

            DeadLine_Draft = DeadLine_Draft & "<Status>" & vbCrLf
            DeadLine_Draft = DeadLine_Draft & "<StatusType type='" & "CarrierDocCutoffDate" & "'/>" & vbCrLf
            DeadLine_Draft = DeadLine_Draft & "<StatusDate>" & Convert.ToDateTime(dl_draft).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
            DeadLine_Draft = DeadLine_Draft & "<StatusTime>" & Convert.ToDateTime(dl_draft).ToString("HHmm") & "</StatusTime>" & vbCrLf
            DeadLine_Draft = DeadLine_Draft & "</Status>" & vbCrLf
        End If

    End Function

    Private Function BookingNumberTransportation() As String


        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Then Exit Function
        BookingNumberTransportation = ""
        If UCase(ProcessoDT.Rows(0)("num_master").ToString()) = "JOB" Then
            BookingNumberTransportation = "<ReferenceType type= 'BookingNumber'>" & vbCrLf

            BookingNumberTransportation = BookingNumberTransportation & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("nr_reserva")) = True, "", ProcessoDT.Rows(0)("nr_reserva").ToString()) & "</ReferenceNumber>" & vbCrLf
        Else
            BookingNumberTransportation = "<ReferenceType type= 'HouseBookingNumber'>" & vbCrLf

            BookingNumberTransportation = BookingNumberTransportation & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("processo")) = True, "", ProcessoDT.Rows(0)("processo").ToString()) & "</ReferenceNumber>" & vbCrLf
        End If
        BookingNumberTransportation = BookingNumberTransportation & "</ReferenceType>"


    End Function

    Private Function BookingNumberHouse() As String

        BookingNumberHouse = ""
        BookingNumberHouse = "<References type= 'BookingNo'>" & vbCrLf

        BookingNumberHouse = CStr(CDbl(BookingNumberHouse & "<ReferenceNumber>") + IIf(IsDBNull(ProcessoDT.Rows(0)("nr_reserva")) = True, "", ProcessoDT.Rows(0)("nr_reserva").ToString()) + CDbl("</ReferenceNumber>") + CDbl(vbCrLf))
        BookingNumberHouse = BookingNumberHouse & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        BookingNumberHouse = BookingNumberHouse & "</References>"


    End Function

    Private Function DestinationControlIndYN() As String

        DestinationControlIndYN = ""

        DestinationControlIndYN = "<References type= 'DestinationControlIndYN'>" & vbCrLf
        DestinationControlIndYN = DestinationControlIndYN & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        DestinationControlIndYN = DestinationControlIndYN & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        DestinationControlIndYN = DestinationControlIndYN & "</References>"


    End Function

    Private Function SupplierRelatedNonrelatedUndYN() As String

        SupplierRelatedNonrelatedUndYN = ""

        SupplierRelatedNonrelatedUndYN = "<References type= 'SupplierRelatedNonrelatedUndYN'>" & vbCrLf
        SupplierRelatedNonrelatedUndYN = SupplierRelatedNonrelatedUndYN & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        SupplierRelatedNonrelatedUndYN = SupplierRelatedNonrelatedUndYN & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        SupplierRelatedNonrelatedUndYN = SupplierRelatedNonrelatedUndYN & "</References>"


    End Function

    Private Function BDPBillingInvoiceNumber() As String

        Dim ltempDT As New Data.DataTable
        If StrPais <> "Argentina" Then
            StrSql = "select fatcod, FatDtVenc dt from fatura where left(fatcod,16)='" & ProcessoDT.Rows(0)("processo").ToString() & "' and cd_pes='" & IIf(UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I", ProcessoDT.Rows(0)("cd_consig").ToString(), ProcessoDT.Rows(0)("processo").ToString()) & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Else

            StrSql = "select Top 1 F.Numero fatcod, F.Dt_Fatura dt  from Fatura_Arg F join Fatura_ARG_Det FD on f.ID_Fat=fd.ID_Fat where left(Num_Proc,16)='" & strProcesso & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        End If
        BDPBillingInvoiceNumber = ""

        For Each ltempDR As DataRow In ltempDT.Rows
            BDPBillingInvoiceNumber = BDPBillingInvoiceNumber & "<References type= 'BDPBillingInvoiceNumber'>" & vbCrLf

            BDPBillingInvoiceNumber = BDPBillingInvoiceNumber & "<ReferenceNumber>" & IIf(IsDBNull(ltempDR.Item("fatcod")) = True, "", ltempDT.Rows(0)("fatcod").ToString()) & "</ReferenceNumber>" & vbCrLf
            If IsDBNull(ltempDR.Item("dt")) = True Then
                BDPBillingInvoiceNumber = BDPBillingInvoiceNumber & "<ReferenceDate></ReferenceDate>" & vbCrLf

            Else
                BDPBillingInvoiceNumber = BDPBillingInvoiceNumber & "<ReferenceDate>" & IIf(IsDBNull(ltempDR.Item("dt")) = True, "", Convert.ToDateTime(ltempDR.Item("dt")).ToString("yyyyMMdd")) & "</ReferenceDate>" & vbCrLf

            End If
            BDPBillingInvoiceNumber = BDPBillingInvoiceNumber & "</References>"

        Next






    End Function

    Private Function XITNNumber() As String


        XITNNumber = ""

        'Desabilitado em 23/03/2011
        Exit Function

        XITNNumber = "<References type= 'XITNNumber'>" & vbCrLf
        XITNNumber = XITNNumber & "<ReferenceNumber>" & "</ReferenceNumber>" & vbCrLf
        XITNNumber = XITNNumber & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        XITNNumber = XITNNumber & "</References>"




    End Function

    Private Function ExportEIN() As String

        ExportEIN = ""

        ExportEIN = "<References type= 'ExportEIN'>" & vbCrLf
        ExportEIN = ExportEIN & "<ReferenceNumber>" & "</ReferenceNumber>" & vbCrLf
        ExportEIN = ExportEIN & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        ExportEIN = ExportEIN & "</References>"


    End Function

    Private Function CountryReferences(ByRef strLocal As String, ByRef StrTag As String) As String

        Dim ltempDT As New Data.DataTable

        CountryReferences = ""

        StrSql = "Select Cd_Pais From Localidade with(nolock)  where cd_local='" & strLocal & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            CountryReferences = "<References type='" & StrTag & "'>" & vbCrLf


            CountryReferences = CountryReferences & "<ReferenceNumber>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cd_pais")) = True, "", ltempDT.Rows(0)("cd_pais").ToString())) & "</ReferenceNumber>" & vbCrLf
            '   ExportEIN = ExportEIN + "<ReferenceDate>" + "</ReferenceDate>" + vbCrLf
            CountryReferences = CountryReferences & "</References>"

        End If


    End Function

    Private Function HazardousDetail(ByRef strPRoduto As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spINTProdutoPerigoso_Sel '" & strPRoduto & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            HazardousDetail = "<HazardousDetail>"
            HazardousDetail = HazardousDetail & "<UNNumber>" & CStr(ltempDT.Rows(0)("unCode").ToString()) & "</UNNumber>"
            HazardousDetail = HazardousDetail & "<Class type='UN'>" & CStr(ltempDT.Rows(0)("classCode").ToString()) & "</Class>"
            HazardousDetail = HazardousDetail & "<FlashPoint>" & Replace(Replace(CStr(ltempDT.Rows(0)("flashpoint").ToString()), "<", ""), ">", "") & "</FlashPoint>"
            HazardousDetail = HazardousDetail & "<FlashPointUnit>" & VB.Left(ltempDT.Rows(0)("meAsureCode").ToString(), 1) & "</FlashPointUnit>        "
            'HazardousDetail = HazardousDetail & "<HazmatMaterialName>" + lTempDT.Rows(0)("hazMat_Name_Material").toString() + "</HazmatMaterialName>"
            HazardousDetail = HazardousDetail & "<PackageGroup>" + ltempDT.Rows(0)("packingCode").ToString() + "</PackageGroup>"
            HazardousDetail = HazardousDetail & "<HazmatMaterialName>" + "<![CDATA[" & (ltempDT.Rows(0)("hazMat_Name_Material").ToString()) & "]]>" + "</HazmatMaterialName>"
            HazardousDetail = HazardousDetail & "<HazmatDesc>" + "<![CDATA[" & (ltempDT.Rows(0)("hazMat_description").ToString()) & "]]>" + "</HazmatDesc>"
            HazardousDetail = HazardousDetail & "<HazmatContact>" & CStr(ltempDT.Rows(0)("hazmat_phone").ToString()) & "</HazmatContact>"
            HazardousDetail = HazardousDetail & "<HighTemp>" & "</HighTemp>"
            HazardousDetail = HazardousDetail & "<LowTemp>" & "</LowTemp>"
            HazardousDetail = HazardousDetail & "<Indicator>Y</Indicator>"
            HazardousDetail = HazardousDetail & "</HazardousDetail>"
        Else
            HazardousDetail = "<HazardousDetail>"
            HazardousDetail = HazardousDetail & "<UNNumber></UNNumber>"
            HazardousDetail = HazardousDetail & "<FlashPoint></FlashPoint>"
            HazardousDetail = HazardousDetail & "<HazmatMaterialName></HazmatMaterialName>"
            HazardousDetail = HazardousDetail & "<HazmatDesc></HazmatDesc>"
            HazardousDetail = HazardousDetail & "<HazmatContact></HazmatContact>"
            HazardousDetail = HazardousDetail & "<HighTemp></HighTemp>"
            HazardousDetail = HazardousDetail & "<LowTemp></LowTemp>"
            HazardousDetail = HazardousDetail & "<Indicator>N</Indicator>"
            HazardousDetail = HazardousDetail & "</HazardousDetail>"
        End If

        '
        '

        '  <HighTemp />
        '  <LowTemp />
        '  <Indicator>N</Indicator>

    End Function

    Private Function Hazardous() As String

        Hazardous = ""

        'Desabilitado em 23/03/2011
        Exit Function

        Hazardous = "<References type= 'Hazardous'>" & vbCrLf
        Hazardous = Hazardous & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        Hazardous = Hazardous & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        Hazardous = Hazardous & "</References>"


    End Function

    Private Function CargoType() As String

        CargoType = ""

        If StrType = "301" Then
            CargoType = "<References type= 'CargoType'>" & vbCrLf

            CargoType = CargoType & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("cd_tp_carga_301")) = True, "", ProcessoDT.Rows(0)("cd_tp_carga_301").ToString()) + "</ReferenceNumber>" + vbCrLf
            CargoType = CargoType & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
            CargoType = CargoType & "</References>"

        Else

            CargoType = "<References type= 'CargoType'>" & vbCrLf

            CargoType = CargoType & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("tipo_carga")) = True, "", ProcessoDT.Rows(0)("tipo_carga").ToString()) + "</ReferenceNumber>" + vbCrLf
            CargoType = CargoType & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
            CargoType = CargoType & "</References>"


        End If



    End Function

    Private Function ManifestHoldIndYN() As String

        ManifestHoldIndYN = ""

        ManifestHoldIndYN = "<References type= 'ManifestHoldIndYN'>" & vbCrLf
        ManifestHoldIndYN = ManifestHoldIndYN & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        ManifestHoldIndYN = ManifestHoldIndYN & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        ManifestHoldIndYN = ManifestHoldIndYN & "</References>"


    End Function

    Private Function CustomsEntrytypeCode(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "IM"
                StrSql = "select canal_lim canal from llp_imp_mar with(nolock) where num_proc_lim='" & strProcesso & "'"
            Case "IA"
                StrSql = "select canal_lia canal from llp_imp_aer with(nolock)  where num_proc_lia='" & strProcesso & "'"
            Case "IO"
                StrSql = "select canal_lio canal from llp_imp_out with(nolock)  where num_proc_lio='" & strProcesso & "'"
            Case "EA"
                StrSql = "select canal_lea canal from llp_exp_aer with(nolock)  where num_proc_lea='" & strProcesso & "'"
            Case "EM"
                StrSql = "select canal_lem canal from llp_exp_mar with(nolock)  where num_proc_lem='" & strProcesso & "'"
            Case "EO"
                StrSql = "select canal_leo canal from llp_exp_out with(nolock)  where num_proc_leo='" & strProcesso & "'"
        End Select


        CustomsEntrytypeCode = ""

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)



        CustomsEntrytypeCode = "<References type= 'CustomsEntrytypeCode'>" & vbCrLf

        CustomsEntrytypeCode = CustomsEntrytypeCode & "<ReferenceNumber>" + IIf(IsDBNull(ltempDT.Rows(0)("canal")) = True, "", ltempDT.Rows(0)("canal").ToString()) + "</ReferenceNumber>" + vbCrLf
        CustomsEntrytypeCode = CustomsEntrytypeCode & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        CustomsEntrytypeCode = CustomsEntrytypeCode & "</References>"


    End Function

    Private Function HouseCarrierSCAC() As String


        Dim ltempDT As New Data.DataTable

        HouseCarrierSCAC = ""

        If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" And Mid(ProcessoDT.Rows(0)("num_master").ToString(), 3, 3) <> "CLI" And VB.Left(UCase(ProcessoDT.Rows(0)("processo").ToString()), 2) <> "IO" And VB.Left(UCase(ProcessoDT.Rows(0)("processo").ToString()), 2) <> "EO" Then

            HouseCarrierSCAC = "<ReferenceType type='HouseCarrierSCAC'>" & vbCrLf
            HouseCarrierSCAC = HouseCarrierSCAC & "<ReferenceNumber>" & "BOPT" & "</ReferenceNumber>" & vbCrLf
            HouseCarrierSCAC = HouseCarrierSCAC & "</ReferenceType>"
            HouseCarrierSCAC = HouseCarrierSCAC & "<ReferenceType type='HouseCarrier'>" & vbCrLf
            HouseCarrierSCAC = HouseCarrierSCAC & "<ReferenceNumber>" & "BDP TRANSPORT." & "</ReferenceNumber>" & vbCrLf
            HouseCarrierSCAC = HouseCarrierSCAC & "</ReferenceType>"

        Else
            If StrType = "301" Then
                StrSql = "select cd_vendor from pessoa_llp with(nolock)  where cd_pes='" & ProcessoDT.Rows(0)("Cd_Transportadora").ToString() & "' "
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)

                If ltempDT.Rows.Count > 0 Then

                    If IsDBNull(ltempDT.Rows(0)("Cd_Vendor")) = False Then
                        HouseCarrierSCAC = "<ReferenceType type='HouseCarrierSCAC'>" + vbCrLf
                        HouseCarrierSCAC = HouseCarrierSCAC + "<ReferenceNumber>" + ltempDT.Rows(0)("Cd_Vendor").ToString() + "</ReferenceNumber>" + vbCrLf
                        HouseCarrierSCAC = HouseCarrierSCAC + "</ReferenceType>"
                    End If

                End If
            End If
        End If


    End Function

    Private Function ConsolIndicator() As String

        ConsolIndicator = ""
        ConsolIndicator = "<References type= 'ConsolIndicator'>" & vbCrLf


        If IsDBNull(ProcessoDT.Rows(0)("num_master")) = False Then
            If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" And Mid(ProcessoDT.Rows(0)("num_master").ToString(), 3, 3) <> "CLI" Then
                ConsolIndicator = ConsolIndicator & "<ReferenceNumber>" & "C" & "</ReferenceNumber>" & vbCrLf
            Else
                ConsolIndicator = ConsolIndicator & "<ReferenceNumber>" & "D" & "</ReferenceNumber>" & vbCrLf
            End If
        Else
            ConsolIndicator = ConsolIndicator & "<ReferenceNumber>" & "D" & "</ReferenceNumber>" & vbCrLf
        End If


        ConsolIndicator = ConsolIndicator & "</References>"


    End Function

    Private Function BDPTransportYN() As String

        BDPTransportYN = ""
        BDPTransportYN = "<References type= 'BDPTransportYN'>" & vbCrLf


        If IsDBNull(ProcessoDT.Rows(0)("num_master")) = False Then
            If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" And Mid(ProcessoDT.Rows(0)("num_master").ToString(), 3, 3) <> "CLI" And VB.Left(UCase(ProcessoDT.Rows(0)("processo").ToString()), 2) <> "IO" And VB.Left(UCase(ProcessoDT.Rows(0)("processo").ToString()), 2) <> "EO" Then
                BDPTransportYN = BDPTransportYN & "<ReferenceNumber>" & "Y" & "</ReferenceNumber>" & vbCrLf
            Else
                BDPTransportYN = BDPTransportYN & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
            End If
        Else
            BDPTransportYN = BDPTransportYN & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        End If


        BDPTransportYN = BDPTransportYN & "</References>"


    End Function

    Private Function CarrierContractNbr() As String

        CarrierContractNbr = ""
        CarrierContractNbr = "<References type= 'CarrierContractNbr'>" & vbCrLf


        If IsDBNull(ProcessoDT.Rows(0)("num_master")) = False Then
            If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" And Mid(ProcessoDT.Rows(0)("num_master").ToString(), 3, 3) <> "CLI" Then
                CarrierContractNbr = CarrierContractNbr & "<ReferenceNumber>" & "105010" & "</ReferenceNumber>" & vbCrLf
            Else
                CarrierContractNbr = CarrierContractNbr & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
            End If
        Else
            CarrierContractNbr = CarrierContractNbr & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        End If


        CarrierContractNbr = CarrierContractNbr & "</References>"


    End Function

    Private Function InsightRefNum() As String

        InsightRefNum = ""
        InsightRefNum = "<References type= 'InsightRefNum'>" & vbCrLf


        If IsDBNull(ProcessoDT.Rows(0)("num_master")) = False Then
            If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" And Mid(ProcessoDT.Rows(0)("num_master").ToString(), 3, 3) <> "CLI" Then
                InsightRefNum = InsightRefNum & "<ReferenceNumber>" & "190183" & "</ReferenceNumber>" & vbCrLf
            Else
                InsightRefNum = InsightRefNum & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
            End If
        Else
            InsightRefNum = InsightRefNum & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
        End If


        InsightRefNum = InsightRefNum & "</References>"


    End Function

    Private Function ConsolidationNumber() As String

        ConsolidationNumber = ""
        If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" Then
            ConsolidationNumber = "<References type= 'ConsolNumber'>" & vbCrLf
            ConsolidationNumber = ConsolidationNumber & "<ReferenceNumber>" + ProcessoDT.Rows(0)("num_master").ToString() + "</ReferenceNumber>" + vbCrLf
            ConsolidationNumber = ConsolidationNumber & "</References>"
        End If

    End Function

    Private Function ExpressMBOLInd() As String

        Dim ltempDT As New Data.DataTable


        If IsDBNull(ProcessoDT.Rows(0)("num_master")) = True Then Exit Function

        StrSql = "select campo_dados from campo_processo with(nolock)  where num_proc='" + ProcessoDT.Rows(0)("num_master").ToString() + "' and id_campo=126"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If ltempDT.Rows(0)("campo_dados").ToString() = 1 Then
                ExpressMBOLInd = "<References type= 'ExpressMBOLInd'>" & vbCrLf
                ExpressMBOLInd = ExpressMBOLInd & "<ReferenceNumber>" & "Y" & "</ReferenceNumber>" & vbCrLf
                ExpressMBOLInd = ExpressMBOLInd & "</References>"
            Else
                ExpressMBOLInd = "<References type= 'ExpressMBOLInd'>" & vbCrLf
                ExpressMBOLInd = ExpressMBOLInd & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
                ExpressMBOLInd = ExpressMBOLInd & "</References>"
            End If
        Else
            ExpressMBOLInd = "<References type= 'ExpressMBOLInd'>" & vbCrLf
            ExpressMBOLInd = ExpressMBOLInd & "<ReferenceNumber>" & "N" & "</ReferenceNumber>" & vbCrLf
            ExpressMBOLInd = ExpressMBOLInd & "</References>"


        End If



    End Function

    Private Function ConsolStatus() As String
        Dim StrStatus As String


        If IsDBNull(ProcessoDT.Rows(0)("ATA")) = False Then
            StrStatus = "Arrived"
        Else

            If IsDBNull(ProcessoDT.Rows(0)("ATD")) = False Then
                StrStatus = "In Transit"
            Else
                StrStatus = "Booking"
            End If
        End If


        ConsolStatus = ""
        If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" Then
            ConsolStatus = "<References type= 'ConsolStatus'>" & vbCrLf

            ConsolStatus = ConsolStatus & "<ReferenceNumber>" & StrStatus & "</ReferenceNumber>" & vbCrLf
            ConsolStatus = ConsolStatus & "</References>"
        End If

    End Function

    Private Function HouseBillOfLading() As String

        HouseBillOfLading = ""

        If IsDBNull(ProcessoDT.Rows(0)("HAWB")) = False And IsDBNull(ProcessoDT.Rows(0)("mawb")) = False Then
            If ProcessoDT.Rows(0)("HAWB").ToString() = ProcessoDT.Rows(0)("mawb").ToString() Then Exit Function
        End If

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"

                If IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True Then
                    HouseBillOfLading = ""
                Else
                    HouseBillOfLading = "<References type= 'HouseBillOfLading'>" & vbCrLf
                    HouseBillOfLading = HouseBillOfLading & "<ReferenceNumber>" + ProcessoDT.Rows(0)("HAWB").ToString() + "</ReferenceNumber>" + vbCrLf
                    HouseBillOfLading = HouseBillOfLading & "</References>"
                End If
            Case "A"

                If IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True Then
                    HouseBillOfLading = ""
                Else
                    HouseBillOfLading = ""
                    '                    HouseBillOfLading = "<References type= 'HouseAirWayBill'>" + vbCrLf
                    '                    HouseBillOfLading = HouseBillOfLading + "<ReferenceNumber>" + RsProcesso!hawb + "</ReferenceNumber>" + vbCrLf
                    '                    HouseBillOfLading = HouseBillOfLading + "</References>"
                End If
            Case "O" 'PENDENTE

                If IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True Then
                    HouseBillOfLading = ""
                Else
                    HouseBillOfLading = "<References type= 'HouseBillOfLading'>" & vbCrLf
                    HouseBillOfLading = HouseBillOfLading & "<ReferenceNumber>" + ProcessoDT.Rows(0)("HAWB").ToString() + "</ReferenceNumber>" + vbCrLf
                    HouseBillOfLading = HouseBillOfLading & "</References>"
                End If

        End Select
    End Function

    Private Function PlaceofReceipt() As String


        If StrType <> "301" Then
            If IsDBNull(ProcessoDT.Rows(0)("cd_origem")) = False Then
                PlaceofReceipt = "<Origin Type='PlaceofReceipt'>" & vbCrLf
                PlaceofReceipt = PlaceofReceipt & "<OriginName>" & Nome_Local(ProcessoDT.Rows(0)("cd_origem").ToString()) & "</OriginName>" & vbCrLf
                PlaceofReceipt = PlaceofReceipt & "</Origin>" & vbCrLf
                PlaceofReceipt = PlaceofReceipt & "<OriginCodeType Type='UNLOCCode'>" & vbCrLf
                PlaceofReceipt = PlaceofReceipt & "<OriginCode>" & BiTri(ProcessoDT.Rows(0)("cd_origem").ToString()) & "</OriginCode>" & vbCrLf
                PlaceofReceipt = PlaceofReceipt & "</OriginCodeType>" & vbCrLf
            Else
                PlaceofReceipt = ""
            End If
            '    If RsProcesso!cd_tp_oper <> "DDP" And RsProcesso!cd_tp_oper <> "DDU" Then
            '        PlaceofReceipt = ""
            '    End If
        End If
    End Function

    Private Function PlaceofDelivery() As String


        If IsDBNull(ProcessoDT.Rows(0)("cd_origem")) = False Then
            PlaceofDelivery = "<Origin Type='PlaceofDelivery'>" & vbCrLf
            PlaceofDelivery = PlaceofDelivery & "<OriginName>" & Nome_Local(ProcessoDT.Rows(0)("cd_origem").ToString()) & "</OriginName>" & vbCrLf
            PlaceofDelivery = PlaceofDelivery & "</Origin>" & vbCrLf
            PlaceofDelivery = PlaceofDelivery & "<OriginCodeType Type='UNLOCCode'>" & vbCrLf
            PlaceofDelivery = PlaceofDelivery & "<OriginCode>" & BiTri(ProcessoDT.Rows(0)("cd_origem").ToString()) & "</OriginCode>" & vbCrLf
            PlaceofDelivery = PlaceofDelivery & "</OriginCodeType>" & vbCrLf
        Else
            PlaceofDelivery = ""
        End If

        If ProcessoDT.Rows(0)("cd_tp_oper").ToString() <> "DDP" And ProcessoDT.Rows(0)("cd_tp_oper").ToString() <> "DDU" Then
            PlaceofDelivery = ""
        End If

    End Function

    Private Function Verifica_Localidades() As Boolean

        Verifica_Localidades = True
        If ProcessoDT.Rows.Count = 0 Then
            Verifica_Localidades = False
            Exit Function
        End If

        If Verifica_UN(BiTri(ProcessoDT.Rows(0)("cd_dst").ToString())) = False Then
            Verifica_Localidades = False
        End If


        If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = False Then
            If Verifica_UN(BiTri(ProcessoDT.Rows(0)("cd_destino").ToString())) = False Then
                Verifica_Localidades = False
            End If
        End If

        If IsDBNull(ProcessoDT.Rows(0)("cd_origem")) = False Then
            If Verifica_UN(BiTri(ProcessoDT.Rows(0)("cd_origem").ToString())) = False Then
                Verifica_Localidades = False
            End If
        End If

        If IsDBNull(ProcessoDT.Rows(0)("cd_org")) = True Then
            Verifica_Localidades = False
            Exit Function
        End If

        If Verifica_UN(BiTri(ProcessoDT.Rows(0)("cd_org"))) = False Then
            Verifica_Localidades = False
        End If

    End Function

    Private Function Verifica_UN(ByRef strCodigo As String) As Boolean

        Dim ltempDT As New Data.DataTable


        StrSql = "select * from BDPINT_Localidade with(nolock)  where ISO_2_LTR_CNTRY_CD='" & VB.Left(strCodigo, 2) & "' and UN_LOCTN_CD='" & VB.Right(strCodigo, 3) & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Verifica_UN = True
        Else
            Verifica_UN = False
            StrSql = "insert into BDPSmart_Log_Erro values('" & ProcessoDT.Rows(0)("processo").ToString() & "',getdate(),null,'" & "Localidade Invalida:" & strCodigo & "')"
            sqlCnn.ExecutaComando(StrSql)


        End If
        Verifica_UN = True

    End Function

    Private Function Transportation() As String

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                Transportation = "<Transportation Responsibility='Carrier' MethodofTransportation='Ocean' LegType='Primary'>" & vbCrLf
                Transportation = Transportation & "<Origin Type='PortofLoad'>" & vbCrLf
                Transportation = Transportation & "<OriginName>" & Nome_Local(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginName>" & vbCrLf
                Transportation = Transportation & "</Origin>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("cd_origem").ToString()) = False Then
                    Transportation = Transportation & Schedule("D", ProcessoDT.Rows(0)("cd_origem").ToString())
                End If
                Transportation = Transportation & "<OriginCodeType Type='UNLOCCode'>" & vbCrLf
                Transportation = Transportation & "<OriginCode>" & BiTri(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginCode>" & vbCrLf
                Transportation = Transportation & "</OriginCodeType>" & vbCrLf
                Transportation = Transportation & "<OriginCountryCode>" & Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginCountryCode>"
                Transportation = Transportation & "<OriginDate type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETD").ToString(), "yyyymmdd") & "</OriginDate>" & vbCrLf

            Case "A"
                Transportation = "<Transportation Responsibility='Carrier' MethodofTransportation='A' LegType='First'>" & vbCrLf
                Transportation = Transportation & "<OriginCodeType Type=""UNLOCCode"">" & vbCrLf
                Transportation = Transportation & "<OriginCode>" & BiTri(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginCode>" & vbCrLf
                Transportation = Transportation & "</OriginCodeType>" & vbCrLf

                Transportation = Transportation & "<OriginCodeType Type=""IATACode"">" & vbCrLf
                Transportation = Transportation & "<OriginCode>" + (ProcessoDT.Rows(0)("cd_org")).ToString() + "</OriginCode>" + vbCrLf
                Transportation = Transportation & "</OriginCodeType>" & vbCrLf


                If IsDBNull(ProcessoDT.Rows(0)("cd_origem").ToString()) = False Then
                    Transportation = Transportation & Schedule("D", ProcessoDT.Rows(0)("cd_origem").ToString())
                End If
                Transportation = Transportation & "<OriginCountryCode>" & Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginCountryCode>" & vbCrLf
                Transportation = Transportation & "<OriginDate type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETD").ToString(), "yyyymmdd") & "</OriginDate>" & vbCrLf

            Case "O"
                If ProcessoDT.Rows(0)("Tipo_Tranp").ToString() = "T" Then
                    Transportation = "<Transportation Responsibility='Carrier' MethodofTransportation='T' LegType='Primary'>" & vbCrLf
                Else
                    Transportation = "<Transportation Responsibility='Carrier' MethodofTransportation='R' LegType='Primary'>" & vbCrLf
                End If
                '    Transportation = Transportation + "<InlandCarrier>" + Armador + "</InlandCarrier>"
                Transportation = Transportation & "<Origin Type='PortofLoad'>" & vbCrLf
                Transportation = Transportation & "<OriginName>" & Nome_Local(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginName>" & vbCrLf
                Transportation = Transportation & "</Origin>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("cd_origem")) = False Then
                    Transportation = Transportation & Schedule("D", ProcessoDT.Rows(0)("cd_origem").ToString())
                End If
                Transportation = Transportation & "<OriginCodeType Type='UNLOCCode'>" & vbCrLf
                Transportation = Transportation & "<OriginCode>" & BiTri(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginCode>" & vbCrLf
                Transportation = Transportation & "</OriginCodeType>" & vbCrLf
                Transportation = Transportation & "<OriginCountryCode>" & Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</OriginCountryCode>"
                Transportation = Transportation & "<OriginDate type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETD").ToString(), "yyyymmdd") & "</OriginDate>" & vbCrLf

        End Select


        If String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATD").ToString()) = False Then
            ' If CDate(ProcessoDT.Rows(0)("ATD").ToString()) <= CDate(VB6.Format(Now, "dd/mm/yyyy")) Then
            If CDate(ProcessoDT.Rows(0)("ATD").ToString()) <= Date.Now.Date Then
                Transportation = Transportation & "<OriginDate type='Actual'>" & VB6.Format(ProcessoDT.Rows(0)("ATD").ToString(), "yyyymmdd") & "</OriginDate>" & vbCrLf
            End If
        End If

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Or VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EA" Then
            Transportation = Transportation & "<OriginTime type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETD").ToString(), "hhmm") & "</OriginTime>" & vbCrLf
        End If

        If (VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Or VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EA") And (IsDBNull(ProcessoDT.Rows(0)("ATD")) = False And ProcessoDT.Rows(0)("ATD").ToString() <= VB6.Format(Now, "dd/mm/yyyy")) Then
            Transportation = Transportation & "<OriginTime type='Actual'>" & VB6.Format(ProcessoDT.Rows(0)("ATD").ToString(), "hhmm") & "</OriginTime>" & vbCrLf
        End If

        '*********************PlaceofDelivery - 31/01
        '    If PlaceofDelivery <> "" Then
        '        Transportation = Transportation + PlaceofDelivery
        '    End If


        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                Transportation = Transportation & "<Destination LocationType='PortofDischarge'>" & vbCrLf
                Transportation = Transportation & "<DestinationName>" & Upper_Case(Nome_Local(ProcessoDT.Rows(0)("cd_dst").ToString())) & "</DestinationName>" & vbCrLf
                Transportation = Transportation & "</Destination>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = False Then
                    Transportation = Transportation & Schedule("K", ProcessoDT.Rows(0)("cd_destino").ToString())
                End If
                Transportation = Transportation & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf
                Transportation = Transportation & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
                Transportation = Transportation & "</DestinationCodeType>" & vbCrLf
                Transportation = Transportation & "<DestinationCountryCode>" & Pais(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCountryCode>" & vbCrLf
                Transportation = Transportation & "<DestinationDate type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETA").ToString(), "yyyymmdd") & "</DestinationDate>" & vbCrLf

                If String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATA").ToString()) = False Then
                    'If String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATA").toString()) = False Then
                    If CDate(ProcessoDT.Rows(0)("ATA").ToString()) <= Date.Now.Date Then
                        Transportation = Transportation & "<DestinationDate type='Actual'>" & VB6.Format(ProcessoDT.Rows(0)("ATA").ToString(), "yyyymmdd") & "</DestinationDate>" & vbCrLf
                    End If
                    'End If
                End If


                If StrType.Equals("ShippingInstruction") Then
                    Transportation = Transportation & Transportation_TypeofMoveCodeSI()
                Else
                    If ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDP" Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDU" Then
                        Transportation = Transportation & "<TypeofMoveDescription>DOOR TO DOOR</TypeofMoveDescription>" & vbCrLf
                    Else
                        If ProcessoDT.Rows(0)("cd_tp_oper").ToString() <> "FOB" And ProcessoDT.Rows(0)("cd_tp_oper").ToString() <> "FCA" Then
                            Transportation = Transportation & "<TypeofMoveDescription>DOOR TO PORT</TypeofMoveDescription>" & vbCrLf
                        Else
                            Transportation = Transportation & "<TypeofMoveDescription>PORT TO PORT</TypeofMoveDescription>" & vbCrLf
                        End If
                    End If
                End If
            Case "A"
                Transportation = Transportation & "<DestinationCodeType Type=""UNLOCCode"">" & vbCrLf
                Transportation = Transportation & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
                Transportation = Transportation & "</DestinationCodeType>" & vbCrLf
                Transportation = Transportation & "<DestinationCodeType Type=""IATACode"">" & vbCrLf
                Transportation = Transportation & "<DestinationCode>" + (ProcessoDT.Rows(0)("cd_dst")).ToString() + "</DestinationCode>" + vbCrLf
                Transportation = Transportation & "</DestinationCodeType>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("cd_destino")) = False Then
                    Transportation = Transportation & Schedule("K", ProcessoDT.Rows(0)("cd_destino").ToString())
                End If
                Transportation = Transportation & "<DestinationCountryCode>" & Pais(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCountryCode>" & vbCrLf
                Transportation = Transportation & "<DestinationDate type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETA").ToString(), "yyyymmdd") & "</DestinationDate>" & vbCrLf


                'Cadu Verificar
                If String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATA").ToString()) = False Then
                    If CDate(ProcessoDT.Rows(0)("ATA").ToString()) <= CDate(VB6.Format(Now, "dd/mm/yyyy")) Then
                        Transportation = Transportation & "<DestinationDate type='Actual'>" & VB6.Format(ProcessoDT.Rows(0)("ATA").ToString(), "yyyymmdd") & "</DestinationDate>" & vbCrLf
                    End If
                End If
                Transportation = Transportation & "<DestinationTime type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETA").ToString(), "hhmm") & "</DestinationTime>" & vbCrLf

                If (VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Or VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EA") Then
                    If String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATA").ToString()) = False And String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATD").ToString()) = False Then
                        If CDate(ProcessoDT.Rows(0)("ATD").ToString()) <= CDate(VB6.Format(Now, "dd/mm/yyyy")) Then
                            Transportation = Transportation & "<DestinationTime type='Actual'>" & VB6.Format(ProcessoDT.Rows(0)("ATA").ToString(), "hhmm") & "</DestinationTime>" & vbCrLf
                        End If
                    End If
                End If
                '  Transportation = Transportation + "<TypeofMoveDescription>PORT TO PORT H/H (DUP)</TypeofMoveDescription>" + vbCrLf
                If ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDP" Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDU" Then

                    Transportation = Transportation & "<TypeofMoveDescription>DOOR TO DOOR</TypeofMoveDescription>" & vbCrLf
                    Transportation = Transportation & "<TypeofMoveCode Type='DD'></TypeofMoveCode>" & vbCrLf

                Else
                    Transportation = Transportation & "<TypeofMoveDescription>AIRPORT TO AIRPORT H/H (DUP)</TypeofMoveDescription>" & vbCrLf
                    Transportation = Transportation & "<TypeofMoveCode Type='AA'></TypeofMoveCode>" & vbCrLf


                End If
            Case "O"
                Transportation = Transportation & "<Destination LocationType='PortofDischarge'>" & vbCrLf
                Transportation = Transportation & "<DestinationName>" & Upper_Case(Nome_Local(ProcessoDT.Rows(0)("cd_dst").ToString())) & "</DestinationName>" & vbCrLf
                Transportation = Transportation & "</Destination>" & vbCrLf
                Transportation = Transportation & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf
                Transportation = Transportation & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
                Transportation = Transportation & "</DestinationCodeType>" & vbCrLf
                'Port Of entry
                Transportation = Transportation & "<Destination LocationType='PortofEntry'>" & vbCrLf
                Transportation = Transportation & "<DestinationName>" & Upper_Case(Nome_Local(ProcessoDT.Rows(0)("cd_dst").ToString())) & "</DestinationName>" & vbCrLf
                Transportation = Transportation & "</Destination>" & vbCrLf
                Transportation = Transportation & "<DestinationCodeType Type='UNLOCCode'>" & vbCrLf
                Transportation = Transportation & "<DestinationCode>" & BiTri(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCode>" & vbCrLf
                Transportation = Transportation & "</DestinationCodeType>" & vbCrLf

                Transportation = Transportation & "<DestinationCountryCode>" & Pais(ProcessoDT.Rows(0)("cd_dst").ToString()) & "</DestinationCountryCode>" & vbCrLf
                Transportation = Transportation & "<DestinationDate type='Estimated'>" & VB6.Format(ProcessoDT.Rows(0)("ETA").ToString(), "yyyymmdd") & "</DestinationDate>" & vbCrLf

                If String.IsNullOrEmpty(ProcessoDT.Rows(0)("ATA").ToString()) = False Then
                    If CDate(ProcessoDT.Rows(0)("ATA").ToString()) <= CDate(VB6.Format(Now, "dd/mm/yyyy")) Then
                        Transportation = Transportation & "<DestinationDate type='Actual'>" & VB6.Format(ProcessoDT.Rows(0)("ATA").ToString(), "yyyymmdd") & "</DestinationDate>" & vbCrLf
                    End If
                End If
                If ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDP" Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDU" Then
                    Transportation = Transportation & "<TypeofMoveDescription>DOOR TO DOOR</TypeofMoveDescription>" & vbCrLf
                    Transportation = Transportation & "<TypeofMoveCode Type='DD'></TypeofMoveCode>" & vbCrLf
                Else
                    If ProcessoDT.Rows(0)("cd_tp_oper").ToString() <> "FOB" And ProcessoDT.Rows(0)("cd_tp_oper").ToString() <> "FCA" Then
                        Transportation = Transportation & "<TypeofMoveDescription>DOOR TO PORT (DUP)</TypeofMoveDescription>" & vbCrLf
                        Transportation = Transportation & "<TypeofMoveCode Type='DP'></TypeofMoveCode>" & vbCrLf
                    Else
                        Transportation = Transportation & "<TypeofMoveDescription>PORT TO PORT H/H (DUP)</TypeofMoveDescription>" & vbCrLf
                        Transportation = Transportation & "<TypeofMoveCode Type='PP'></TypeofMoveCode>" & vbCrLf

                    End If
                End If

        End Select
        ' Transportation = Transportation + "<DestinationDate Type='Estimated'>" + ETA + "</DestinationDate>" + vbCrLf


        Transportation = Transportation & "<Carrier>" & vbCrLf
        Transportation = Transportation & "<CarrierName>" & Armador() & "</CarrierName>" & vbCrLf
        Transportation = Transportation & "<CarrierCode type='SCAC'>" & SCAC(ProcessoDT.Rows(0)("processo").ToString()) & "</CarrierCode>" & vbCrLf
        'Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
        '    Case "M"
        '        Transportation = Transportation & "<CarrierCode type='SCAC'>" & SCAC(ProcessoDT.Rows(0)("processo").ToString()) & "</CarrierCode>" & vbCrLf
        '    Case "A"
        '        '            If UCase((Left(RsProcesso!Processo, 2))) = "EA" Then
        '        Transportation = Transportation & "<CarrierCode type='IATACode'>" & SCAC(ProcessoDT.Rows(0)("processo").ToString()) & "</CarrierCode>" & vbCrLf
        '        '           Else
        '        '             Transportation = Transportation + "<CarrierCode>" + SCAC(RsProcesso!Processo) + "</CarrierCode>" + vbCrLf
        '        '          End If
        '    Case "O"
        '        Transportation = Transportation & "<CarrierCode type='SCAC'>" & SCAC(ProcessoDT.Rows(0)("processo").ToString()) & "</CarrierCode>" & vbCrLf
        'End Select
        Transportation = Transportation & "</Carrier>"

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                Transportation = Transportation & "<Vessel>" & vbCrLf

                If IsDBNull(ProcessoDT.Rows(0)("navio")) = False Then

                    Transportation = Transportation & "<VesselName>" & Upper_Case(IIf(IsDBNull(ProcessoDT.Rows(0)("navio")) = True, "", Upper_Case(ProcessoDT.Rows(0)("navio").ToString()))) & "</VesselName>" & vbCrLf
                    Transportation = Transportation & VesselCode()
                Else
                    Transportation = Transportation & "<VesselName></VesselName>" & vbCrLf
                End If
                Transportation = Transportation & "</Vessel>" & vbCrLf
        End Select

        Transportation = Transportation & "<PrepaidorCollect>" + ProcessoDT.Rows(0)("tp_frete").ToString() + "</PrepaidorCollect>" + vbCrLf

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                '            If UCase(RsProcesso!num_master) <> "JOB" Then
                '                Transportation = Transportation + "<ReferenceType type='MasterBillofLadingNumber'>" + vbCrLf
                '                Transportation = Transportation + "<ReferenceNumber>" + MAWB_MEM + "</ReferenceNumber>" + vbCrLf
                '                Transportation = Transportation + "</ReferenceType>" + vbCrLf
                '            End If
                If Trim(MAWB_MEM) <> "" Then

                    Transportation = Transportation & "<ReferenceType type='MasterBillofLadingNumber'>" & vbCrLf
                    Transportation = Transportation & "<ReferenceNumber>" & MAWB_MEM() & "</ReferenceNumber>" & vbCrLf
                    Transportation = Transportation & "</ReferenceType>" & vbCrLf
                End If

                Transportation = Transportation & "<ReferenceType type='HouseBillofLadingNumber'>" & vbCrLf
                Transportation = Transportation & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True, "", ProcessoDT.Rows(0)("HAWB").ToString()) & "</ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf

            Case "A"
                Transportation = Transportation & "<ReferenceType type='MasterAirwayBill'>" & vbCrLf
                Transportation = Transportation & "<ReferenceNumber>" & MAWB_MEM() & "</ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf

                Transportation = Transportation & "<ReferenceType type='MasterBillofLadingNumber'>" & vbCrLf
                Transportation = Transportation & "<ReferenceNumber>" & MAWB_MEM() & "</ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf

                Transportation = Transportation & "<ReferenceType type='HouseAirwayBill'>" & vbCrLf
                Transportation = Transportation & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True, "", ProcessoDT.Rows(0)("HAWB").ToString()) & "</ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf

                Transportation = Transportation & "<ReferenceType type='HouseBillofLadingNumber'>" & vbCrLf
                Transportation = Transportation & "<ReferenceNumber>" & IIf(IsDBNull(ProcessoDT.Rows(0)("HAWB")) = True, "", ProcessoDT.Rows(0)("HAWB").ToString()) & "</ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf

            Case "O"
                Transportation = Transportation & "<ReferenceType type='MasterBillofLadingNumber'>" & vbCrLf
                Transportation = Transportation & "<ReferenceNumber>" & MAWB_MEM() & "</ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf



        End Select

        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                Transportation = Transportation & "<ReferenceType type='VoyageNumber'>" & vbCrLf

                Transportation = Transportation & "<ReferenceNumber><![CDATA[" & IIf(IsDBNull(ProcessoDT.Rows(0)("viagem")) = True, "", ProcessoDT.Rows(0)("viagem").ToString()) & "]]></ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf
                Transportation = Transportation & AddShipPoint()

            Case "A"
                Transportation = Transportation & "<ReferenceType type='FlightNumber'>" & vbCrLf

                Transportation = Transportation & "<ReferenceNumber><![CDATA[" & IIf(IsDBNull(ProcessoDT.Rows(0)("viagem")) = True, "", ProcessoDT.Rows(0)("viagem").ToString()) & "]]></ReferenceNumber>" & vbCrLf
                Transportation = Transportation & "</ReferenceType>" & vbCrLf


                '       Case "O"
                '
                '            Transportation = Transportation + "<ReferenceType type='VoyageNumber'>" + vbCrLf
                '            Transportation = Transportation + "<ReferenceNumber>" + IIf(IsNull(RsProcesso!hawb) = True, "", RsProcesso!hawb) + "</ReferenceNumber>" + vbCrLf
                '            Transportation = Transportation + "</ReferenceType>" + vbCrLf
        End Select

        Transportation = Transportation & FreightAmount()

        '        Transportation = Transportation & "<ReferenceType type='FreightAmount'>"
        '        Transportation = Transportation & "<ReferenceNumber>" & Replace(IIf(IsDBNull(ProcessoDT.Rows(0)("vlr_frete")) = True, 0, ProcessoDT.Rows(0)("vlr_frete").ToString()), ",", ".") & "</ReferenceNumber>" & vbCrLf
        '        Transportation = Transportation & "</ReferenceType>" & vbCrLf

        '***** COURIER
        'Courier
        If CourierCD() <> "" Then
            Transportation = Transportation & CourierCD()
        End If

        If CourierAWB() <> "" Then
            Transportation = Transportation & CourierAWB()
        End If
        Transportation = Transportation & HouseCarrierSCAC()

        If StrType.Equals("ShippingInstruction") Then
            Transportation = Transportation & HouseCarrierSCACSI(strProcesso)
        End If

        Transportation = Transportation & BookingNumberTransportation()

        'Booking Number alterado em 30-1
        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2)) <> "IA" Then

            If IsDBNull(ProcessoDT.Rows(0)("nr_reserva")) = False Then
                If UCase(ProcessoDT.Rows(0)("num_master").ToString()) <> "JOB" Then
                    Transportation = Transportation & "<ReferenceType type='BookingNumber'>" & vbCrLf

                    Transportation = Transportation & "<ReferenceNumber>" & Replace(Trim(IIf(IsDBNull(ProcessoDT.Rows(0)("nr_reserva")) = True, "", VB.Left(ProcessoDT.Rows(0)("nr_reserva").ToString(), 30))), "/", "") & "</ReferenceNumber>" & vbCrLf
                    Transportation = Transportation & "</ReferenceType>" & vbCrLf
                End If
            End If
        End If


        If StrPais = "Brasil" Then
            If AWBDataBR() <> "" Then
                Transportation = Transportation & AWBDataBR()
            End If
        Else
            If AWBData() <> "" Then
                Transportation = Transportation & AWBData()
            End If
        End If

        Transportation = Transportation & "</Transportation>"
        'HAWB alterado em 06-03

    End Function

    Private Function MAWB_MEM() As String


        MAWB_MEM = IIf(IsDBNull(ProcessoDT.Rows(0)("mawb")) = True, "", ProcessoDT.Rows(0)("mawb").ToString())

    End Function

    Private Function VesselCode() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select lloyd from navio with(nolock) where nome_navio like '" & VB.Left(ProcessoDT.Rows(0)("navio").ToString(), 7) & "%'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            VesselCode = "<VesselCode type='Lloyds'>" & CStr(ltempDT.Rows(0)("lloyd").ToString()) & "</VesselCode>"
        Else
            VesselCode = "<VesselCode type='Lloyds'>" & CStr("00000") & "</VesselCode>"
        End If

    End Function

    Private Function SCAC(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable




        Select Case UCase(VB.Left(strProcesso, 2))
            Case "EM"
                If StrType = "301" Then
                    StrSql = "select SAP_Code SCAC from armador  ARM with(nolock) " & "Join LLP_exp_mar mas with(nolock) on arm.cd_armador=mas.cd_armador_Lem " & " where num_proc_Lem='" & strProcesso & "'"
                Else
                    StrSql = "select SCAC from armador  ARM with(nolock) " & "Join LLP_exp_mar mas with(nolock) on arm.cd_armador=mas.cd_armador_Lem " & " where num_proc_Lem='" & strProcesso & "'"
                End If
            Case "EA"
                StrSql = "select SCAC from CIA_AEREA ARM with(nolock) " & "Join LLP_Exp_AEr LLP with(nolock) on arm.cd_CIA_AER=LLP.Cd_CiaAerea_Lea " & " where num_proc_Lea='" & strProcesso & "'"
            Case "IA"
                StrSql = "select SCAC from cia_Aerea ARM with(nolock) " & " Join Job_Imp_Aer JOB with(nolock) on ARM.cd_Cia_Aer=JOB.Cd_cia_Aer " & " Where num_proc_hia= '" & strProcesso & "'"
            Case "IM"
                StrSql = "select SCAC from armador  ARM with(nolock) " & "Join job_Imp_mar JOB with(nolock) on arm.cd_armador=JOB.cd_armador " & " where num_proc_him='" & strProcesso & "'"
            Case "IO"
                StrSql = "select Cd_Vendor SCAC from Pessoa_LLP  ARM with(nolock) " & "Join LLP_imp_out LLP with(nolock) on arm.cd_pes=LLP.cd_carrier " & " where num_proc_lio='" & strProcesso & "'"
            Case "EO"
                StrSql = "select Cd_Vendor SCAC from Pessoa_LLP  ARM with(nolock) " & "Join LLP_exp_out LLP with(nolock)  on arm.cd_pes=LLP.cd_carrier " & " where num_proc_leo='" & strProcesso & "'"
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            SCAC = ""
        Else

            SCAC = IIf(IsDBNull(ltempDT.Rows(0)("SCAC")) = True, "", ltempDT.Rows(0)("SCAC").ToString())
        End If

        If SCAC = "" Then
            Select Case UCase(VB.Left(strProcesso, 2))
                Case "EA"
                    StrSql = "select scac from cia_aerea ARM with(nolock) " & " Join Master_Exp_Aer MAS with(nolock) on MAS.cd_cia_aer=ARM.cd_cia_Aer " & " Where num_proc_mea='" & VB.Left(strProcesso, 14) & "'"
                Case "EM"
                    StrSql = "select SCAC from Master_Exp_MAr MAS with(nolock) " & " Join Armador ARM with(nolock)  on ARM.cd_armador=MAS.cd_armador " & " where num_proc_mem='" & VB.Left(strProcesso, 14) & "'"
            End Select
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            If ltempDT.Rows.Count > 0 Then

                SCAC = IIf(IsDBNull(ltempDT.Rows(0)("SCAC")) = True, "", ltempDT.Rows(0)("SCAC").ToString())
            Else
                SCAC = ""
            End If

        End If

    End Function

    Private Function Armador() As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EM"
                StrSql = "select nome_armador Armador from armador arm with(nolock)  " & "Join LLP_Exp_Mar mas with(nolock)  on arm.cd_armador=mas.cd_armador_LEM " & " where num_proc_lem='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            Case "EA"
                StrSql = "select nome_cia_aer Armador from Cia_Aerea arm with(nolock) " & "Join LLP_Exp_AER mas with(nolock)  on arm.cd_cia_aer=mas.Cd_CiaAerea_Lea " & " where num_proc_lea='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            Case "IM"
                StrSql = "select nome_armador Armador from armador arm with(nolock) " & "Join Job_Imp_Mar mas with(nolock)  on arm.cd_armador=mas.cd_armador " & " where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            Case "IA"
                StrSql = "select nome_cia_aer Armador from Cia_Aerea arm with(nolock) " & "Join job_imp_aer mas with(nolock) on arm.cd_cia_aer=mas.cd_cia_Aer " & " where num_proc_hia='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            Case "IO"
                StrSql = "select Nome_Raz_SOC Armador from Pessoa arm with(nolock) " & "Join Pessoa_LLP PP with(nolock) on pp.cd_pes=Arm.cd_pes " & " Join LLP_Imp_out LLP with(nolock) on Cd_Carrier=pp.cd_pes " & " where num_proc_lio='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            Case "EO"
                StrSql = "select Nome_Raz_SOC Armador from Pessoa arm with(nolock) " & "Join Pessoa_LLP PP with(nolock) on pp.cd_pes=Arm.cd_pes " & " Join LLP_exp_out LLP with(nolock)  on pp.cd_pes=cd_carrier " & " where num_proc_leo='" & ProcessoDT.Rows(0)("processo").ToString() & "'"

        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            Armador = ""
        Else

            Armador = IIf(IsDBNull(ltempDT.Rows(0)("Armador")) = True, "", Upper_Case(ltempDT.Rows(0)("Armador").ToString()))
        End If

        ltempDT = New DataTable()

        If Armador = "" Then
            Select Case UCase(VB.Left(strProcesso, 2))
                Case "EA"
                    StrSql = "select Nome_Cia_Aer Armador from cia_aerea ARM with(nolock) " & " Join Master_Exp_Aer MAS with(nolock) on MAS.cd_cia_aer=ARM.cd_cia_Aer " & " Where num_proc_mea='" & VB.Left(strProcesso, 14) & "'"
                Case "EM"
                    StrSql = "select Nome_ARmador Armador from Master_Exp_MAr MAS with(nolock) " & " Join Armador ARM with(nolock) on ARM.cd_armador=MAS.cd_armador  " & " Where num_proc_mem='" & VB.Left(strProcesso, 14) & "' and nome_armador <> '0'"

            End Select
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                Armador = IIf(IsDBNull(ltempDT.Rows(0)("Armador")) = True, "", ltempDT.Rows(0)("Armador").ToString())
            Else
                Armador = ""
            End If

        End If

    End Function

    Private Function Nome_Local(ByRef strLocal As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select nome_local from localidade with(nolock) where cd_local='" & strLocal & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            Nome_Local = Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Nome_Local")) = True, "", ltempDT.Rows(0)("Nome_Local").ToString()))
        Else
            Nome_Local = ""
        End If



    End Function

    Private Function BiTri(ByRef strLocal As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spSmartBITRI_Sel '" & strLocal & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        BiTri = ""
        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("SCAC").ToString()) = False Then

                BiTri = CStr(IIf(IsDBNull(ltempDT.Rows(0)("cd_pais")) = True, "", ltempDT.Rows(0)("cd_pais").ToString()) + VB.Left(ltempDT.Rows(0)("SCAC").ToString(), 3))
            Else

                BiTri = IIf(IsDBNull(ltempDT.Rows(0)("codigo")) = True, "", ltempDT.Rows(0)("codigo").ToString())
            End If
        End If




    End Function

    Private Function Datas(ByRef strTipo As String) As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EM"
                StrSql = "select dt_saida_mem data,eta_mem ETA,etd_mem ETD  from master_exp_mar with(nolock) where num_proc_mem='" & VB.Left(ProcessoDT.Rows(0)("num_master").ToString(), 14) & "'"
            Case "EA"
                StrSql = "select dt_saida_mea Data, eta_mea ETA, etd_mea ETD  from master_exp_aer with(nolock)  where num_proc_mea='" & VB.Left(ProcessoDT.Rows(0)("num_master").ToString(), 14) & "'"
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            Datas = ""
        Else
            Select Case strTipo
                Case "Saida"

                    Datas = IIf(IsDBNull(ltempDT.Rows(0)("Data")) = True, "", VB6.Format(ltempDT.Rows(0)("Data").ToString(), "yyyymmdd"))
                Case "ETA"

                    Datas = IIf(IsDBNull(ltempDT.Rows(0)("ETA")) = True, "", VB6.Format(ltempDT.Rows(0)("ETA").ToString(), "yyyymmdd"))
                Case "ETD"

                    Datas = IIf(IsDBNull(ltempDT.Rows(0)("ETD")) = True, "", VB6.Format(ltempDT.Rows(0)("ETD").ToString(), "yyyymmdd"))
            End Select
        End If

    End Function



    Private Function Actual_CutOff() As String

        Dim ltempDT As New Data.DataTable

        Actual_CutOff = ""
        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM" Then


            If IsDBNull(ProcessoDT.Rows(0)("dl_carga")) = False Then
                If CDate(ProcessoDT.Rows(0)("dl_carga").ToString()) < Now.Date Then
                    Actual_CutOff = "<Events>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<Code>REC</Code>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<Location>" & Nome_Local(ProcessoDT.Rows(0)("cd_org").ToString()) & "</Location>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<LocationUnlocCd>" & BiTri(ProcessoDT.Rows(0)("cd_org").ToString()) & "</LocationUnlocCd>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<Description>In-gate</Description>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<Date>" & VB6.Format(ProcessoDT.Rows(0)("dl_carga").ToString(), "yyyymmdd") & "</Date>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<DateInd />" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "<Time></Time>" & vbCrLf
                    Actual_CutOff = Actual_CutOff & "</Events>"
                End If
            End If
        End If
    End Function
    Private Function EquipmentTotalVolumeMeter(ByVal NumContainer As String) As String

        Dim dtTemp As New DataTable
        '2020-11-10: Added due Scheiner request

        StrSql = "intSmartContainerM3 '" + ProcessoDT.Rows(0)("processo").ToString() + "','" + NumContainer + "'"
        dtTemp = sqlCnn.BuscaInformacoes(StrSql)
        EquipmentTotalVolumeMeter = ""
        If dtTemp.Rows.Count > 0 Then
            EquipmentTotalVolumeMeter = EquipmentTotalVolumeMeter & "<Amounts>"
            EquipmentTotalVolumeMeter = EquipmentTotalVolumeMeter & "<AmountType>EquipmentTotalVolumeMeter</AmountType>"

            EquipmentTotalVolumeMeter = EquipmentTotalVolumeMeter & "<AmountValue>" & CStr(Replace(CStr(IIf(IsDBNull(dtTemp.Rows(0)("VolumeM3")) = True, 0, dtTemp.Rows(0)("VolumeM3").ToString())), ",", ".")) & "</AmountValue>"
            EquipmentTotalVolumeMeter = EquipmentTotalVolumeMeter & "</Amounts>"

        End If

    End Function
    Private Function Container_DET() As String

        Dim ltempDT As New Data.DataTable
        Dim IntCC As Short


        Select Case VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2)
            Case "EM", "EA"
                'StrSql = "select [dbo].[Qty_Container](num_proc_hem) QtyC, cd_smart,nome_tp_cont,num_cont_em num_cont, num_lacre_em num_lacre, Lacre_02_EM Num_Lacre_02,convert(datetime,Dt_Vcto_Devol_EM,105) Dt_Vcto_Devol_EM  from container_mas_exp_mar CM with(nolock)" & " Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont" & " Join container_hou_exp_mar ch with(nolock) on ch.num_proc_mem=cm.num_proc_mem and ch.item_cont_em=cm.item_cont_em" & " where num_proc_hem='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                StrSql = "select [dbo].[Qty_Container](num_proc_hem) QtyC, cd_smart,nome_tp_cont,(case when num_cont_em = '__________-_' then '' else num_cont_em end) num_cont, num_lacre_em num_lacre, Lacre_02_EM Num_Lacre_02,convert(datetime,Dt_Vcto_Devol_EM,105) Dt_Vcto_Devol_EM,CAI.Peso_Bruto_EM_VGM, CAI.UOM_VGM, CAI.Dt_Envio_VGM, CAI.Nome_Responsavel_VGM, CAI.Metodo_VGM" +
                            " from container_mas_exp_mar CM with(nolock)" +
                            " Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont" +
                            " Join container_hou_exp_mar ch with(nolock) on ch.num_proc_mem=cm.num_proc_mem and ch.item_cont_em=cm.item_cont_em" +
                            " left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc and CAI.num_cont = replace(CM.num_cont_em,'-','') and ativo = 1" +
                            " where num_proc_hem= '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            Case "IM", "IA"
                StrSql = "select Dt_Vcto_Devol_IM Dt_Vcto_Devol_Valida, Dt_Devol_IM  Dt_Devol_Valida, convert(datetime,Dt_Vcto_Devol_IM,105) Dt_Vcto_Devol_IM,  convert(datetime,Dt_Devol_IM,105) Dt_Devol_IM,  [dbo].[Qty_Container](num_proc_him) QtyC,cd_smart,nome_tp_cont, num_cont_im num_cont, num_lacre_Im  num_lacre, Lacre_02_IM Num_Lacre_02 from container_mas_imp_mar CM with(nolock)" & " Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont" & " Join container_hou_imp_mar ch with(nolock) on ch.num_proc_mim=cm.num_proc_mim and ch.item_cont_im=cm.item_cont_im" & " where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            IntCC = 1
        Else
            If ltempDT.Rows(0)("qtyc").ToString() = 0 Then
                IntCC = 1
            Else
                IntCC = ltempDT.Rows(0)("qtyc").ToString()
            End If
        End If



        Container_DET = ""
        '2020-11-14: Logic created for Air Shipments due Schneider fields, it is applicable for airshipments 
        If ProcessoDT.Rows(0)("Processo").ToString.Substring(1, 1) = "A" Then
            Container_DET = "<Equipment><EquipmentNumber></EquipmentNumber><SealNumber></SealNumber><SealNumber></SealNumber><EquipmentType></EquipmentType><EquipmentSize></EquipmentSize>"
            Container_DET = Container_DET + Itineraryid("")
            Container_DET = Container_DET & "</Equipment>"
        End If

        For Each lTempDR As DataRow In ltempDT.Rows
            'cadu 5 - 12 - 2020
            'If IsDBNull(lTempDR.Item("num_cont").ToString()) = False Then
            If String.IsNullOrEmpty(lTempDR.Item("num_cont").ToString()) = False Then
                Container_DET = Container_DET & "<Equipment>" & vbCrLf
                Container_DET = Container_DET & "<Measurements type='GrossWeightKilograms'>" & vbCrLf


                'Container_DET = Container_DET & "<MeasurementValue>" & CStr(Replace(CStr(IIf(IsDBNull(ProcessoDT.Rows(0)("Peso_Bruto")) = True, 0, ProcessoDT.Rows(0)("Peso_Bruto").ToString()) / IntCC), ",", ".")) & "</MeasurementValue></Measurements>" & vbCrLf
                Container_DET = Container_DET & "<MeasurementValue>" & CStr(Replace(CStr(IIf(String.IsNullOrEmpty(ProcessoDT.Rows(0)("Peso_Bruto").ToString()), 0, ProcessoDT.Rows(0)("Peso_Bruto").ToString()) / IntCC), ",", ".")) & "</MeasurementValue></Measurements>" & vbCrLf

                'Container_DET = Container_DET & "<EquipmentInitial>" & VB.Left(lTempDR.Item("num_cont").ToString().Replace("-", ""), 4) & "</EquipmentInitial>" & vbCrLf
                Container_DET = Container_DET & "<EquipmentInitial>" & lTempDR.Item("num_cont").ToString().Replace("-", "").Substring(0, 4) & "</EquipmentInitial>" & vbCrLf

                'If Trim(ltempDT.Rows(0)("num_cont").ToString()) <> "" Then
                If String.IsNullOrEmpty(lTempDR.Item("num_cont").ToString()) = False Then
                    'Container_DET = Container_DET & "<EquipmentNumber>" & IIf(Trim(lTempDR.Item("num_cont").ToString()) <> "", CStr(VB.Right(CStr(lTempDR.Item("num_cont").ToString().Replace("-", "")), Len(lTempDR.Item("num_cont").ToString().Replace("-", "")) - 4)), "") & "</EquipmentNumber>" & vbCrLf
                    Dim strNumCont As String
                    strNumCont = lTempDR.Item("num_cont").ToString().Replace("-", "")
                    strNumCont = strNumCont.ToString().Substring(4, strNumCont.Length - 4)
                    Container_DET = Container_DET & "<EquipmentNumber>" + strNumCont + "</EquipmentNumber>" & vbCrLf

                    'Container_DET = Container_DET & "<EquipmentNumber>" & IIf(Trim(lTempDR.Item("num_cont").ToString()) <> "", CStr(VB.Right(CStr(lTempDR.Item("num_cont").ToString().Replace("-", "")), Len(lTempDR.Item("num_cont").ToString().Replace("-", "")) - 4)), "") & "</EquipmentNumber>" & vbCrLf
                Else
                    Container_DET = Container_DET & "<EquipmentNumber>" & "</EquipmentNumber>" & vbCrLf
                End If

                'Container_DET = Container_DET & "<SealNumber>" & IIf(IsDBNull(lTempDR.Item("num_lacre")) = True, "", lTempDR.Item("num_lacre").ToString()) & "</SealNumber>" & vbCrLf
                Container_DET = Container_DET & "<SealNumber>" + IIf(String.IsNullOrEmpty(lTempDR.Item("num_lacre").ToString()), "", lTempDR.Item("num_lacre").ToString()) + "</SealNumber>" & vbCrLf

                'Lacre_02_IM - Segundo Lacre - Adicionado em 22/01/2014
                'If IsDBNull(lTempDR.Item("num_lacre_02").ToString()) = False Then
                'If String.IsNullOrEmpty(lTempDR.Item("num_lacre_02").ToString()) = False Then
                If lTempDR.Item("num_lacre_02").ToString().Length > 0 Then

                    'Container_DET = Container_DET & "<SealNumber>" & IIf(IsDBNull(lTempDR.Item("num_lacre_02")) = True, "", lTempDR.Item("num_lacre_02").ToString()) & "</SealNumber>" & vbCrLf
                    Container_DET = Container_DET & "<SealNumber>" + IIf(String.IsNullOrEmpty(lTempDR.Item("num_lacre_02").ToString()), "", lTempDR.Item("num_lacre_02").ToString()) + "</SealNumber>" & vbCrLf

                End If



                '18-11
                'If VB.Left(lTempDR.Item("nome_tp_cont").ToString(), 2) = "20" Or VB.Left(lTempDR.Item("nome_tp_cont").ToString(), 2) = "40" Then
                If (lTempDR.Item("nome_tp_cont").ToString().Substring(0, 2) = "20" Or lTempDR.Item("nome_tp_cont").ToString().Substring(0, 2) = "40") Then

                    Container_DET = Container_DET & "<EquipmentType>" + lTempDR.Item("cd_smart").ToString() + "</EquipmentType>"

                    'Container_DET = Container_DET & "<EquipmentSize>" & VB.Left(lTempDR.Item("nome_tp_cont").ToString(), 2) & "</EquipmentSize>"
                    Container_DET = Container_DET & "<EquipmentSize>" & lTempDR.Item("nome_tp_cont").ToString().Substring(0, 2) & "</EquipmentSize>"


                End If
                Container_DET = Container_DET & Actual_CutOff()
                'Amounts
                Container_DET = Container_DET & "<Amounts>"
                Container_DET = Container_DET & "<AmountType>" & "EquipmentTotalWeightKG" & "</AmountType>"

                'Container_DET = Container_DET & "<AmountValue>" & CStr(Replace(CStr(IIf(IsDBNull(ProcessoDT.Rows(0)("Peso_Bruto")) = True, 0, ProcessoDT.Rows(0)("Peso_Bruto").ToString()) / IntCC), ",", ".")) & "</AmountValue>"
                Container_DET = Container_DET & "<AmountValue>" & CStr(Replace(CStr(IIf(String.IsNullOrEmpty(ProcessoDT.Rows(0)("Peso_Bruto").ToString()), 0, ProcessoDT.Rows(0)("Peso_Bruto").ToString()) / IntCC), ",", ".")) & "</AmountValue>"

                Container_DET = Container_DET & "</Amounts>"


                Container_DET = Container_DET + EquipmentTotalVolumeMeter(lTempDR.Item("num_cont").ToString())
                Container_DET = Container_DET & AmountsContainerDet(lTempDR.Item("num_cont").ToString())
                Container_DET = Container_DET & AmountsPallets(lTempDR.Item("num_cont").ToString())

                'SOLAS
                'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM" Then
                If ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2) = "EM" Then
                    'If IsDBNull(ltempDT.Rows(0)("Peso_Bruto_EM_VGM")) = False Then
                    If String.IsNullOrEmpty(ltempDT.Rows(0)("Peso_Bruto_EM_VGM").ToString()) = False Then
                        Container_DET = Container_DET & "<Amounts>"
                        Container_DET = Container_DET & "<AmountType>" & "SolasVrfdGrMass" & "</AmountType>"

                        'Container_DET = Container_DET & "<AmountValue>" & CStr(Replace(CStr(IIf(IsDBNull(lTempDR.Item("Peso_Bruto_EM_VGM")) = True, 0, lTempDR.Item("Peso_Bruto_EM_VGM").ToString())), ",", ".")) & "</AmountValue>"
                        Container_DET = Container_DET & "<AmountValue>" & CStr(Replace(CStr(IIf(String.IsNullOrEmpty(lTempDR.Item("Peso_Bruto_EM_VGM").ToString()), 0, lTempDR.Item("Peso_Bruto_EM_VGM").ToString())), ",", ".")) & "</AmountValue>"

                        Container_DET = Container_DET & "<AmountUnit>" & lTempDR.Item("UOM_VGM").ToString() & "</AmountUnit>"
                        Container_DET = Container_DET & "</Amounts>"
                    End If
                End If

                'Load Date
                Container_DET = Container_DET & EquipmentLoadDate()

                'Database
                'If (VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IM") Then
                If ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2) = "IM" Then
                    'If IsDBNull(lTempDR.Item("Dt_Vcto_Devol_Valida")) = False Then
                    If String.IsNullOrEmpty(lTempDR.Item("Dt_Vcto_Devol_Valida").ToString()) = False Then
                        'If lTempDR.Item("Dt_Vcto_Devol_Valida").ToString() <> "" Then
                        Container_DET = Container_DET & "<Dates>"
                        Container_DET = Container_DET & "<Type>" & "ActEquipmentDeliveredEmptyDate" & "</Type>"

                        'Container_DET = Container_DET & "<Date>" & VB6.Format(lTempDR.Item("Dt_Vcto_Devol_IM").ToString(), "yyyymmdd") & "</Date>"
                        Container_DET = Container_DET & "<Date>" & Convert.ToDateTime(lTempDR.Item("Dt_Vcto_Devol_IM").ToString()).ToString("yyyyMMdd") & "</Date>"

                        Container_DET = Container_DET & "<Time>" & "</Time>"
                        Container_DET = Container_DET & "</Dates>"
                        'End If

                    End If


                    'If IsDBNull(ltempDT.Rows(0)("dt_devol_valida")) = False Then
                    If String.IsNullOrEmpty(lTempDR.Item("dt_devol_valida").ToString()) = False Then
                        'If ltempDT.Rows(0)("dt_devol_valida").ToString() <> "" Then
                        Container_DET = Container_DET & "<Dates>"
                        Container_DET = Container_DET & "<Type>" & "EstFreeTimeExpirationDate" & "</Type>"

                        'Container_DET = Container_DET & "<Date>" & VB6.Format(lTempDR.Item("Dt_Devol_IM").ToString(), "yyyymmdd") & "</Date>"
                        Container_DET = Container_DET & "<Date>" & Convert.ToDateTime(lTempDR.Item("Dt_Devol_IM").ToString()).ToString("yyyyMMdd") & "</Date>"

                        Container_DET = Container_DET & "<Time>" & "</Time>"
                        Container_DET = Container_DET & "</Dates>"
                        'End If
                    End If
                End If

                ' Incluso por Erbson 04-09-2014 - Solicitado pelo BDP Australia - Chris Domingues
                'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM" Then
                If ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2) = "EM" Then
                    'If IsDBNull(ltempDT.Rows(0)("Dt_Vcto_Devol_EM")) = False Then
                    If String.IsNullOrEmpty(lTempDR.Item("Dt_Vcto_Devol_EM").ToString()) = False Then
                        Container_DET = Container_DET & "<Dates>"
                        Container_DET = Container_DET & "<Type>" & "ActFreeTimeExpirationDate" & "</Type>"
                        Container_DET = Container_DET & "<Date>" & Convert.ToDateTime(lTempDR.Item("Dt_Vcto_Devol_EM").ToString()).ToString("yyyyMMdd") & "</Date>"
                        Container_DET = Container_DET & "<Time>" & "</Time>"
                        Container_DET = Container_DET & "</Dates>"
                    End If
                    'SOLAS
                    'If IsDBNull(lTempDR.Item("Dt_Envio_VGM")) = False Then
                    If String.IsNullOrEmpty(lTempDR.Item("Dt_Envio_VGM").ToString()) = False Then
                        Container_DET = Container_DET & "<Dates>"
                        Container_DET = Container_DET & "<Type>" & "SolasVerfictnDt" & "</Type>"
                        Container_DET = Container_DET & "<Date>" & Convert.ToDateTime(lTempDR.Item("Dt_Envio_VGM").ToString()).ToString("yyyyMMdd") & "</Date>"
                        Container_DET = Container_DET & "<Time>" & Convert.ToDateTime(lTempDR.Item("Dt_Envio_VGM").ToString()).ToString("HHmm") & "</Time>"
                        Container_DET = Container_DET & "</Dates>"
                    End If
                End If

                Container_DET = Container_DET & ContainerReferenceNumber(ltempDT.Rows(0)("num_cont").ToString())

                'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM" Then
                If ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2) = "EM" Then

                    'SOLAS
                    'If IsDBNull(ltempDT.Rows(0)("Nome_Responsavel_VGM").ToString()) = False Then
                    If String.IsNullOrEmpty(lTempDR.Item("Nome_Responsavel_VGM").ToString()) = False Then
                        Container_DET = Container_DET + "<References type='SolasRespPrty'>"
                        Container_DET = Container_DET + "<ReferenceNumber>" + lTempDR.Item("Nome_Responsavel_VGM").ToString() + "</ReferenceNumber>"
                        Container_DET = Container_DET + "</References>"
                    End If
                    'If IsDBNull(ltempDT.Rows(0)("Nome_Responsavel_VGM").ToString()) = False Then
                    If String.IsNullOrEmpty(lTempDR.Item("Nome_Responsavel_VGM").ToString()) = False Then
                        Container_DET = Container_DET + "<References type='SolasMthd'>"
                        Container_DET = Container_DET + "<ReferenceNumber>" + lTempDR.Item("Metodo_VGM").ToString() + "</ReferenceNumber>"
                        Container_DET = Container_DET + "</References>"
                        '   <References type="SolasCntrlNbr">
                        '<ReferenceNumber></ReferenceNumber>
                        '   </References>
                    End If
                End If

                Container_DET = Container_DET & Legs()

                'Container_DET = Replace(Container_DET, "-", "")
                'Container_DET = Container_DET + ContainerSolas(lTempDT.Rows(0)("num_cont").toString())
                Container_DET = Container_DET + Itineraryid(lTempDR.Item("num_cont").ToString())

                Container_DET = Container_DET & "</Equipment>"
            End If



        Next



    End Function

    Private Function ContainerSolas(ByRef strNumCont As String) As String
        Dim StrTemp As String
        Dim ltempDT As New Data.DataTable

        'StrSql = "spIntSmartVolumeCC_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "','" + strNumCont + "'"
        StrSql = "select CAI.num_proc,CAI.num_cont,CAI.Peso_Bruto_EM_VGM, CAI.UOM_VGM, CAI.Dt_Envio_VGM,CAI.Nome_Responsavel_VGM,(Case When CAI.Metodo_VGM = '1' then '1:Weighing'  When CAI.Metodo_VGM = '2' then '2:Calculating' else NULL End) Metodo_VGM, HOU.DL_VGM from Container_Additional_Info CAI " &
                " join vwHouse_Exp HOU on CAI.num_proc = HOU.Num_Proc " &
                " where CAI.num_proc = '" + ProcessoDT.Rows(0)("processo").ToString() + "' and CAI.num_cont = replace('" + strNumCont + "','-','') and  ativo = 1"


        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        StrTemp = ""

        If ltempDT.Rows.Count > 0 Then
            StrTemp = "<SOLAS-Requirement>"
            StrTemp = StrTemp + "<TransactionControlNumber></TransactionControlNumber>"
            StrTemp = StrTemp + "<Weights>"
            StrTemp = StrTemp + "<VerifiedGrossMass UOM='" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("UOM_VGM")) = True, "", ltempDT.Rows(0)("UOM_VGM").ToString())) + "'>" & CStr(Replace(CStr(IIf(IsDBNull(ltempDT.Rows(0)("Peso_Bruto_EM_VGM")) = True, "", ltempDT.Rows(0)("Peso_Bruto_EM_VGM").ToString())), ",", ".")) & "</VerifiedGrossMass>"
            StrTemp = StrTemp + "</Weights>"
            'StrTemp = StrTemp + "<UOM>" + CStr(IIf(IsDBNull(lTempDT.Rows(0)("UOM_VGM")) = True, "", lTempDT.Rows(0)("UOM_VGM").toString())) + "</UOM>"
            StrTemp = StrTemp + "<Verification>"
            StrTemp = StrTemp + "<Date>" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("Dt_Envio_VGM")) = True, "", Convert.ToDateTime(ltempDT.Rows(0)("Dt_Envio_VGM").ToString()).ToString("yyyyMMdd"))) + "</Date>"
            StrTemp = StrTemp + "<Time>" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("Dt_Envio_VGM")) = True, "", Convert.ToDateTime(ltempDT.Rows(0)("Dt_Envio_VGM").ToString()).ToString("HHmm"))) + "</Time>"
            StrTemp = StrTemp + "<Method>" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("Metodo_VGM")) = True, "", ltempDT.Rows(0)("Metodo_VGM").ToString())) + "</Method>"
            StrTemp = StrTemp + "<Parties>"
            StrTemp = StrTemp + "<ResponsiblePartyonBOL>" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("Nome_Responsavel_VGM")) = True, "", ltempDT.Rows(0)("Nome_Responsavel_VGM").ToString())) + "</ResponsiblePartyonBOL>"
            StrTemp = StrTemp + "<AuthorizedbyShipper></AuthorizedbyShipper>"
            StrTemp = StrTemp + "</Parties>"
            StrTemp = StrTemp + "</Verification>"
            StrTemp = StrTemp + "<VGM_Cutoff>"
            StrTemp = StrTemp + "<Date>" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("DL_VGM")) = True, "", Convert.ToDateTime(ltempDT.Rows(0)("DL_VGM").ToString()).ToString("yyyyMMdd"))) + "</Date>"
            StrTemp = StrTemp + "<Time Timezone='" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("DL_VGM")) = True, "", "BRT")) + "'>" + CStr(IIf(IsDBNull(ltempDT.Rows(0)("DL_VGM")) = True, "", Convert.ToDateTime(ltempDT.Rows(0)("DL_VGM").ToString()).ToString("HHmm"))) + "</Time>"
            'StrTemp = StrTemp + "<Timezone>" + CStr(IIf(IsDBNull(lTempDT.Rows(0)("DL_VGM")) = True, "", "BRT")) + "</Timezone>"
            StrTemp = StrTemp + "</VGM_Cutoff>"
            StrTemp = StrTemp + "</SOLAS-Requirement>"
        Else
            StrTemp = "<SOLAS-Requirement>"
            StrTemp = StrTemp + "<TransactionControlNumber></TransactionControlNumber>"
            StrTemp = StrTemp + "<Weights>"
            StrTemp = StrTemp + "<VerifiedGrossMass></VerifiedGrossMass>"
            StrTemp = StrTemp + "</Weights>"
            'StrTemp = StrTemp + "<UOM></UOM>"
            StrTemp = StrTemp + "<Verification>"
            StrTemp = StrTemp + "<Date></Date>"
            StrTemp = StrTemp + "<Time></Time>"
            StrTemp = StrTemp + "<Method></Method>"
            StrTemp = StrTemp + "<Parties>"
            StrTemp = StrTemp + "<ResponsiblePartyonBOL></ResponsiblePartyonBOL>"
            StrTemp = StrTemp + "<AuthorizedbyShipper></AuthorizedbyShipper>"
            StrTemp = StrTemp + "</Parties>"
            StrTemp = StrTemp + "</Verification>"
            StrTemp = StrTemp + "<VGM_Cutoff>"
            StrTemp = StrTemp + "<Date></Date>"
            StrTemp = StrTemp + "<Time></Time>"
            'StrTemp = StrTemp + "<Timezone></Timezone>"
            StrTemp = StrTemp + "</VGM_Cutoff>"
            StrTemp = StrTemp + "</SOLAS-Requirement>"
        End If
        ContainerSolas = StrTemp
    End Function

    Private Function ContainerReferenceNumber(ByRef strNumCont As String) As String

        'EM VALIDACAO COM FEDER 07/01/2014

        Dim StrTemp As String
        StrTemp = ""
        Exit Function

        StrTemp = "<References type='ThirdPartyRefNum'>"
        StrTemp = StrTemp & "<ReferenceNumber>" & "47098366" & "</ReferenceNumber>"
        StrTemp = StrTemp & "</References>"

        ContainerReferenceNumber = StrTemp
    End Function

    Private Function AmountsContainerDet(ByRef strNumCont As String) As String

        Dim ltempDT As New Data.DataTable

        If UCase(ProcessoDT.Rows(0)("tipo_carga").ToString()) = "FCL" Then

            StrSql = "spIntSmartVolumeCC_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "','" + strNumCont + "'"

            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            If ltempDT.Rows.Count > 0 Then

                AmountsContainerDet = "<Amounts>"
                AmountsContainerDet = AmountsContainerDet & "<AmountType>" & "EquipmentTotalPackages" & "</AmountType>"
                AmountsContainerDet = AmountsContainerDet & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("qtd").ToString(), "0.00")), ",", ".") & "</AmountValue>"
                AmountsContainerDet = AmountsContainerDet & "</Amounts>"
                'Amounts
            End If
        End If
    End Function

    Private Function AmountsPallets(ByRef strNumCont As String) As String


        Dim ltempDT As New Data.DataTable
        If UCase(ProcessoDT.Rows(0)("tipo_carga").ToString()) = "FCL" Then

            StrSql = "spIntSmartVolumePLT_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "','" + strNumCont + "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                AmountsPallets = "<Amounts>"
                AmountsPallets = AmountsPallets & "<AmountType>" & "EquipmentTotalPackages" & "</AmountType>"
                AmountsPallets = AmountsPallets & "<AmountValue>" & Replace(CStr(VB6.Format(ltempDT.Rows(0)("qtd").ToString(), "0.00")), ",", ".") & "</AmountValue>"
                AmountsPallets = AmountsPallets & "</Amounts>"
                'Amounts
            End If
        End If
    End Function

    Private Function EquipmentLoadDate() As String

        Dim ltempDT As New Data.DataTable

        EquipmentLoadDate = ""

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then
            StrSql = "select dt_conclusao from tarefas_processos with(nolock) where num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "' and id_task=10 and dt_conclusao is not null"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            If ltempDT.Rows.Count > 0 Then
                EquipmentLoadDate = EquipmentLoadDate & "<Dates>"
                EquipmentLoadDate = EquipmentLoadDate & "<Type>" & "EquipmentLoadDate" & "</Type>"
                EquipmentLoadDate = EquipmentLoadDate & "<Date>" & VB6.Format(ltempDT.Rows(0)("dt_conclusao").ToString(), "yyyymmdd") & "</Date>"
                EquipmentLoadDate = EquipmentLoadDate & "<Time>" & "</Time>"
                EquipmentLoadDate = EquipmentLoadDate & "</Dates>"
            End If
        End If


    End Function

    Private Function Billing_Date() As String

        Dim ltempDT As New Data.DataTable
        Dim StrDtFat As String
        '        StrSql = "select max(FatDtVenc-30) data from fatura where left(fatcod,16)='" & RsProcesso!processo & "' and fatstatus=1"

        '     StrSql = "select min(emissao) Data from base_nota_Fiscal with(nolock)  Join vwcta_Cte CTA with(nolock)  on cta.num_nf_hia=nota_fiscal and cta.ref_acesso_nf_hia=ref_Acesso where num_proc_hia='" + RsProcesso!processo + "'"
        StrSql = "select dt_conclusao data from tarefas_processos with(nolock) where id_Task=40 and dt_conclusao is not null"
        StrSql = "spSmartBilledDate_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Billing_Date = ""


        If ltempDT.Rows.Count > 0 Then
            Billing_Date = Billing_Date & "<Status>" & vbCrLf
            Billing_Date = Billing_Date & "<StatusType type='" & "BilledDate" & "'/>" & vbCrLf

            If IsDBNull(ltempDT.Rows(0)("Data")) = True Then
                Billing_Date = Billing_Date & "<StatusDate>" & "</StatusDate>" & vbCrLf
            Else
                Billing_Date = Billing_Date & "<StatusDate>" & VB6.Format(ltempDT.Rows(0)("Data").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
            End If
            Billing_Date = Billing_Date & "</Status>" & vbCrLf

        End If

    End Function

    Private Function BillofLadingBackDate() As String

        BillofLadingBackDate = ""


        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM" Or IsDBNull(ProcessoDT.Rows(0)("ATD")) = True Then
            Exit Function
        End If




        BillofLadingBackDate = BillofLadingBackDate & "<Status>" & vbCrLf
        BillofLadingBackDate = BillofLadingBackDate & "<StatusType type='" & "BillofLadingBackDate" & "'/>" & vbCrLf
        BillofLadingBackDate = BillofLadingBackDate & "<StatusDate>" & VB6.Format(CDate(ProcessoDT.Rows(0)("ATD").ToString()).AddDays(-1), "yyyymmdd") & "</StatusDate>" & vbCrLf
        BillofLadingBackDate = BillofLadingBackDate & "</Status>" & vbCrLf



    End Function

    Private Function Eventos() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select * from evento_house EH with(nolock)  " & " Join Tipo_evento TV with(nolock)   on TV.tpeid=EH.tpeId" & " Where num_proc_h='" & ProcessoDT.Rows(0)("processo").ToString() & "'"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Eventos = ""

        For Each lTempDR As DataRow In ltempDT.Rows
            Eventos = Eventos & "<Status>" & vbCrLf
            Eventos = Eventos & "<StatusType type='" + lTempDR.Item("TpeRefExchange").ToString() + "'/>" + vbCrLf
            Eventos = Eventos & "<StatusDate>" & VB6.Format(lTempDR.Item("evhdata").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
            Eventos = Eventos & "</Status>" & vbCrLf
        Next



    End Function

    'Private Function Task() As String

    '    Dim ltempDT As New Data.DataTable

    '    StrSql = "spInt_Task '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)

    '    Task = ""
    '    'RequestedPlantShipDate
    '    'Previsoes

    '    For Each lTempDR As DataRow In ltempDT.Rows
    '        If IsDBNull(ltempDT.Rows(0)("Smart_Previsao")) = False Then
    '            Task = Task & "<Status>" & vbCrLf
    '            Task = Task & "<StatusType type='" + lTempDR.Item("Smart_Previsao").ToString() + "'/>" + vbCrLf
    '            If ltempDT.Rows(0)("Smart_Previsao").ToString() = "RequestedPlantShipDate" Then
    '                'If PGI(ProcessoDT.Rows(0)("processo").ToString()) <> "" Then
    '                '    Task = Task & "<StatusDate>" & PGI(ProcessoDT.Rows(0)("processo").ToString()) & "</StatusDate>" & vbCrLf
    '                'Else
    '                Task = Task & "<StatusDate>" & VB6.Format(lTempDR.Item("dt_previsao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '                'End If
    '            Else
    '                Task = Task & "<StatusDate>" & VB6.Format(lTempDR.Item("dt_previsao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '            End If

    '            Task = Task & "</Status>"
    '        End If
    '    Next


    '    StrSql = "spInt_Task '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
    '    ltempDT = New DataTable()
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)

    '    For Each lTempDR As DataRow In ltempDT.Rows
    '        If IsDBNull(lTempDR.Item("Smart_Conclusao")) = False And IsDBNull(lTempDR.Item("dt_conclusao")) = False Then
    '            Task = Task & "<Status>" & vbCrLf
    '            Task = Task & "<StatusType type='" + lTempDR.Item("Smart_Conclusao").ToString() + "'/>" + vbCrLf
    '            Task = Task & "<StatusDate>" & VB6.Format(lTempDR.Item("dt_conclusao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '            Task = Task & "</Status>" & vbCrLf
    '        End If
    '    Next



    'End Function

    Private Function PGI(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable

        If VB.Left(strProcesso, 1) = "I" Then Exit Function

        StrSql = "select max(hsgdataFU) Data from hist_geral with(nolock) where hsgprocesso='" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            PGI = ""
        Else
            PGI = VB6.Format(ltempDT.Rows(0)("Data").ToString(), "yyyymmdd")
        End If

    End Function

    Private Function Fecha_Header() As String

        Fecha_Header = "</Header>"

    End Function

    Private Function Fecha_Arquivo() As String

        Fecha_Arquivo = "</Request>"

    End Function

    Private Function ETD() As String

        ETD = "<Status>" & vbCrLf
        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                ETD = ETD & "<StatusType type='EstimatedPortofLoadDate'/>" & vbCrLf
            Case "A"
                ETD = ETD & "<StatusType type='FlightEstimatedTimeofDeparture'/>" & vbCrLf
            Case "O"
                ETD = ETD & "<StatusType type='EstimatedPortofLoadDate'/>" & vbCrLf
        End Select

        ETD = ETD & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETD")) = True, "", ProcessoDT.Rows(0)("ETD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ETD = ETD & "</Status>"

    End Function

    Private Function EstPortofDepartureDate() As String

        EstPortofDepartureDate = "<Status>" & vbCrLf
        EstPortofDepartureDate = EstPortofDepartureDate & "<StatusType type='EstimatedPortofLoadDate'/>" & vbCrLf

        EstPortofDepartureDate = EstPortofDepartureDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETD")) = True, "", ProcessoDT.Rows(0)("ETD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        EstPortofDepartureDate = EstPortofDepartureDate & "</Status>"

    End Function

    Private Function ATA() As String

        ATA = "<Status>" & vbCrLf
        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                ATA = ATA & "<StatusType type='ActualPortofLoadDate'/>" & vbCrLf
            Case "A"
                ATA = ATA & "<StatusType type='FlightEstimatedTimeofDeparture'/>" & vbCrLf
            Case "O"
                ATA = ATA & "<StatusType type='ActualPortofLoadDate'/>" & vbCrLf
        End Select

        ATA = ATA & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ATA = ATA & "</Status>"

    End Function

    Private Function ConsolETADate() As String

        ConsolETADate = "<Status>" & vbCrLf
        ConsolETADate = ConsolETADate & "<StatusType type='ConsolETADate'/>" & vbCrLf

        ConsolETADate = ConsolETADate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ConsolETADate = ConsolETADate & "</Status>"

    End Function

    Private Function ConsolFreightArrivalDate() As String

        ConsolFreightArrivalDate = "<Status>" & vbCrLf
        ConsolFreightArrivalDate = ConsolFreightArrivalDate & "<StatusType type='ConsolFreightArrivalDate'/>" & vbCrLf

        ConsolFreightArrivalDate = ConsolFreightArrivalDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ConsolFreightArrivalDate = ConsolFreightArrivalDate & "</Status>"

    End Function

    Private Function ConsolFreightDeliveryDate() As String

        ConsolFreightDeliveryDate = "<Status>" & vbCrLf
        ConsolFreightDeliveryDate = ConsolFreightDeliveryDate & "<StatusType type='ConsolFreightDeliveryDate'/>" & vbCrLf

        ConsolFreightDeliveryDate = ConsolFreightDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATA")) = True, "", ProcessoDT.Rows(0)("ATA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ConsolFreightDeliveryDate = ConsolFreightDeliveryDate & "</Status>"

    End Function

    Private Function MstActPortofDepartureDate() As String

        MstActPortofDepartureDate = "<Status>" & vbCrLf
        MstActPortofDepartureDate = MstActPortofDepartureDate & "<StatusType type='MstActPortofDepartureDate'/>" & vbCrLf

        MstActPortofDepartureDate = MstActPortofDepartureDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        MstActPortofDepartureDate = MstActPortofDepartureDate & "</Status>"

    End Function

    Private Function MstEstPortofDepartureDate() As String

        MstEstPortofDepartureDate = "<Status>" & vbCrLf
        MstEstPortofDepartureDate = MstEstPortofDepartureDate & "<StatusType type='MstActPortofDepartureDate'/>" & vbCrLf

        MstEstPortofDepartureDate = MstEstPortofDepartureDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETD")) = True, "", ProcessoDT.Rows(0)("ETD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        MstEstPortofDepartureDate = MstEstPortofDepartureDate & "</Status>"

    End Function

    Private Function MstActPortofArrivalDate() As String

        MstActPortofArrivalDate = "<Status>" & vbCrLf
        MstActPortofArrivalDate = MstActPortofArrivalDate & "<StatusType type='MstActPortofArrivalDate'/>" & vbCrLf

        MstActPortofArrivalDate = MstActPortofArrivalDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATA")) = True, "", ProcessoDT.Rows(0)("ATA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        MstActPortofArrivalDate = MstActPortofArrivalDate & "</Status>"

    End Function

    Private Function MstEstPortofArrivalDate() As String

        MstEstPortofArrivalDate = "<Status>" & vbCrLf
        MstEstPortofArrivalDate = MstEstPortofArrivalDate & "<StatusType type='MstEstPortofArrivalDate'/>" & vbCrLf

        MstEstPortofArrivalDate = MstEstPortofArrivalDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        MstEstPortofArrivalDate = MstEstPortofArrivalDate & "</Status>"

    End Function

    Private Function ConsolOpenedDate() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spSmartMaster_Sel '" + ProcessoDT.Rows(0)("num_master").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            ConsolOpenedDate = "<Status>" & vbCrLf
            ConsolOpenedDate = ConsolOpenedDate & "<StatusType type='ConsolOpenedDate'/>" & vbCrLf

            ConsolOpenedDate = ConsolOpenedDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data_Registro")) = True, "", ltempDT.Rows(0)("Data_Registro").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ConsolOpenedDate = ConsolOpenedDate & "</Status>"
        End If

    End Function


    Private Function ConsolDocsRcvddate() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select dt_conclusao Data from tarefas_master where id_task=16 and num_proc='" + ProcessoDT.Rows(0)("num_master").ToString() + "' and dt_conclusao is not null"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            ConsolDocsRcvddate = "<Status>" & vbCrLf
            ConsolDocsRcvddate = ConsolDocsRcvddate & "<StatusType type='ConsolDocsRcvddate'/>" & vbCrLf

            ConsolDocsRcvddate = ConsolDocsRcvddate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data")) = True, "", ltempDT.Rows(0)("Data").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ConsolDocsRcvddate = ConsolDocsRcvddate & "</Status>"
        End If

    End Function


    Private Function ConsolPostedDate() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select dt_conclusao Data from tarefas_master with(nolock) where id_task=26 and num_proc='" + ProcessoDT.Rows(0)("num_master").ToString() + "' and dt_conclusao is not null"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            ConsolPostedDate = "<Status>" & vbCrLf
            ConsolPostedDate = ConsolPostedDate & "<StatusType type='ConsolPostedDate'/>" & vbCrLf

            ConsolPostedDate = ConsolPostedDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data")) = True, "", ltempDT.Rows(0)("Data").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ConsolPostedDate = ConsolPostedDate & "</Status>"
        End If

    End Function


    Private Function ActBookedDate() As String

        Dim ltempDT As New Data.DataTable
        ActBookedDate = ""
        Exit Function
        'Fun��o Desabilitada em 02/07/2012 - Incluida na tabela Tipo_Tarefas

        StrSql = "SELECT DT_CONCLUSAO FROM TAREFAS_PROCESSOS with(nolock) WHERE NUM_PROC='" + ProcessoDT.Rows(0)("processo").ToString() + "' AND ID_TASK='5'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)



        ActBookedDate = ""


        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                ActBookedDate = "<Status>" & vbCrLf
                ActBookedDate = ActBookedDate & "<StatusType type='ActBookedDate'/>" & vbCrLf

                ActBookedDate = ActBookedDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                ActBookedDate = ActBookedDate & "</Status>"
            End If
        End If

    End Function

    Private Function EntryImmediateDeliveryReceivedDate() As String

        Dim ltempDT As New Data.DataTable

        EntryImmediateDeliveryReceivedDate = ""

        '  If Left(RsProcesso!processo, 1) = "E" Then Exit Function

        StrSql = "SELECT DT_CONCLUSAO FROM TAREFAS_PROCESSOS with(nolock) WHERE NUM_PROC='" + ProcessoDT.Rows(0)("processo").ToString() + "' AND ID_TASK='4' and dt_conclusao is not null"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                EntryImmediateDeliveryReceivedDate = "<Status>" & vbCrLf
                If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then
                    EntryImmediateDeliveryReceivedDate = EntryImmediateDeliveryReceivedDate & "<StatusType type='GovernmentPermissionToExportReleaseDate'/>" & vbCrLf
                Else
                    EntryImmediateDeliveryReceivedDate = EntryImmediateDeliveryReceivedDate & "<StatusType type='EntryImmediateDeliveryReceivedDate'/>" & vbCrLf
                End If

                EntryImmediateDeliveryReceivedDate = EntryImmediateDeliveryReceivedDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                EntryImmediateDeliveryReceivedDate = EntryImmediateDeliveryReceivedDate & "</Status>"
            End If
        End If

    End Function

    Private Function ProductDate(ByRef strGMID As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select dt_previsao,dt_conclusao from tarefas_processos with(nolock) where num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "' and id_task=10"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        ProductDate = ""
        If ltempDT.Rows.Count > 0 Then

            ProductDate = ProductDate & "<ProductDates>"
            ProductDate = ProductDate & "<ProductDatesType>" & "EstOriginOfGoodsDepartureDate" & "</ProductDatesType>"

            ProductDate = ProductDate & "<ProductDatesDate>" & IIf(IsDBNull(ltempDT.Rows(0)("dt_previsao")) = True, "", VB6.Format(ltempDT.Rows(0)("dt_previsao").ToString(), "yyyymmdd")) & "</ProductDatesDate>"
            ProductDate = ProductDate & "</ProductDates>"

            ProductDate = ProductDate & "<ProductDates>"
            ProductDate = ProductDate & "<ProductDatesType>" & "ActOriginOfGoodsDepartureDate" & "</ProductDatesType>"

            ProductDate = ProductDate & "<ProductDatesDate>" & IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", VB6.Format(ltempDT.Rows(0)("dt_conclusao").ToString(), "yyyymmdd")) & "</ProductDatesDate>"
            ProductDate = ProductDate & "</ProductDates>"


        End If

        'ImportLicense - Data de Emiss�o da LI
        ltempDT = New DataTable()


        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I" Then
            StrSql = "select cast([dbo].[fBusca_TipoDocCliente]('D','" + ProcessoDT.Rows(0)("processo").ToString() + "',23) as datetime) Saida "
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("saida")) = False Then
                    ProductDate = ProductDate & "<ProductDates>"
                    ProductDate = ProductDate & "<ProductDatesType>" & "ImportLicensePermitIssuanceDate" & "</ProductDatesType>"

                    ProductDate = ProductDate & "<ProductDatesDate>" & IIf(IsDBNull(ltempDT.Rows(0)("saida")) = True, "", VB6.Format(CDate(ltempDT.Rows(0)("saida").ToString()), "yyyymmdd")) & "</ProductDatesDate>"
                    ProductDate = ProductDate & "</ProductDates>"
                End If

            End If
            ltempDT = New DataTable()
        End If

        'Erbson
        'RsTemp = Nothing

        'Incluso por Erbson 04-09-2014 - Solicitado pelo BDP Australia - Chris Domingues
        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2)) = "IM" Or UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2)) = "EM" Then
            StrSql = "spTipoShipContainer_Sel '" & ProcessoDT.Rows(0)("processo").ToString() & "','" & strGMID & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("GA_Ship_Actual_Date")) = False Then
                    ProductDate = ProductDate & "<ProductDates>"
                    ProductDate = ProductDate & "<ProductDatesType>" & "ActGoodsAvailableForShippingDate" & "</ProductDatesType>"

                    ProductDate = ProductDate & "<ProductDatesDate>" & IIf(IsDBNull(ltempDT.Rows(0)("GA_Ship_Actual_Date")) = True, "", VB6.Format(CDate(ltempDT.Rows(0)("GA_Ship_Actual_Date").ToString()), "yyyymmdd")) & "</ProductDatesDate>"
                    ProductDate = ProductDate & "</ProductDates>"
                End If

                If IsDBNull(ltempDT.Rows(0)("GA_Ship_Estimated_Date")) = False Then
                    ProductDate = ProductDate & "<ProductDates>"
                    ProductDate = ProductDate & "<ProductDatesType>" & "EstGoodsAvailableForShippingDate" & "</ProductDatesType>"

                    ProductDate = ProductDate & "<ProductDatesDate>" & IIf(IsDBNull(ltempDT.Rows(0)("GA_Ship_Estimated_Date")) = True, "", VB6.Format(CDate(ltempDT.Rows(0)("GA_Ship_Estimated_Date").ToString()), "yyyymmdd")) & "</ProductDatesDate>"
                    ProductDate = ProductDate & "</ProductDates>"
                End If
            End If

        End If



    End Function



    Private Function ActCustomsPortDate() As String

        Dim ltempDT As New Data.DataTable

        ActCustomsPortDate = ""


        StrSql = "select dt_conclusao,DT_PREVISAO from tarefas_processos with(nolock) where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=15"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then Exit Function
        '22/03/2011 - alterado

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                ActCustomsPortDate = "<Status>" & vbCrLf
                ActCustomsPortDate = ActCustomsPortDate & "<StatusType type='ActCustomsPortDate'/>" & vbCrLf

                ActCustomsPortDate = ActCustomsPortDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                ActCustomsPortDate = ActCustomsPortDate & "</Status>"
            End If

            If IsDBNull(ltempDT.Rows(0)("dt_previsao").ToString()) = False Then
                ActCustomsPortDate = ActCustomsPortDate & "<Status>" & vbCrLf
                ActCustomsPortDate = ActCustomsPortDate & "<StatusType type='EstCustomsPortDate'/>" & vbCrLf

                ActCustomsPortDate = ActCustomsPortDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_previsao")) = True, "", ltempDT.Rows(0)("dt_previsao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                ActCustomsPortDate = ActCustomsPortDate & "</Status>"
            End If


        End If

    End Function




    Private Function ActPlaceOfDeliveryDate() As String

        Dim ltempDT As New Data.DataTable

        ActPlaceOfDeliveryDate = ""


        StrSql = "select dt_conclusao,dt_previsao from tarefas_processos with(nolock) where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=13"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDP" Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDU" Then


            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                    ActPlaceOfDeliveryDate = "<Status>" & vbCrLf
                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "<StatusType type='ActPlaceOfDeliveryDate'/>" & vbCrLf

                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "</Status>"
                End If

                If IsDBNull(ltempDT.Rows(0)("dt_previsao").ToString()) = False Then
                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "<Status>" & vbCrLf
                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "<StatusType type='EstPlaceOfDeliveryDate'/>" & vbCrLf

                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_previsao")) = True, "", ltempDT.Rows(0)("dt_previsao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    ActPlaceOfDeliveryDate = ActPlaceOfDeliveryDate & "</Status>"
                End If


            End If
        End If
    End Function

    Private Function EstDomesticInlandDeliveryDate() As String

        Dim ltempDT As New Data.DataTable

        EstDomesticInlandDeliveryDate = ""


        StrSql = "select dt_conclusao,dt_previsao from tarefas_processos with(nolock) where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=10"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = False Then
                EstDomesticInlandDeliveryDate = "<Status>" & vbCrLf
                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "<StatusType type='ActDomesticInlandDeliveryDate'/>" & vbCrLf

                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(CDate(ltempDT.Rows(0)("dt_conclusao").ToString()).AddDays(2)) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "</Status>"
            End If

            If IsDBNull(ltempDT.Rows(0)("dt_previsao")) = False Then
                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "<Status>" & vbCrLf
                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "<StatusType type='EstDomesticInlandDeliveryDate'/>" & vbCrLf

                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(CDate(ltempDT.Rows(0)("dt_previsao")).AddDays(2)) = True, "", ltempDT.Rows(0)("dt_previsao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                EstDomesticInlandDeliveryDate = EstDomesticInlandDeliveryDate & "</Status>"
            End If


        End If

    End Function

    Private Function ActUnloadedFromVesselDate() As String

        Dim ltempDT As New Data.DataTable

        ActUnloadedFromVesselDate = ""


        If IsDBNull(ProcessoDT.Rows(0)("ATA").ToString()) = False Then

            ActUnloadedFromVesselDate = "<Status>" & vbCrLf
            ActUnloadedFromVesselDate = ActUnloadedFromVesselDate & "<StatusType type='ActUnloadedFromVesselDate'/>" & vbCrLf

            ActUnloadedFromVesselDate = ActUnloadedFromVesselDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATA")) = True, "", ProcessoDT.Rows(0)("ATA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ActUnloadedFromVesselDate = ActUnloadedFromVesselDate & "</Status>"

        End If

    End Function


    Private Function ActPlaceOfReceiptDate() As String

        Dim ltempDT As New Data.DataTable
        Dim IntDias As Short

        ActPlaceOfReceiptDate = ""

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "I" Then Exit Function
        'Altera��o feita 22/03/2011

        StrSql = "select dt_conclusao,dt_previsao from tarefas_processos with(nolock) where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=10"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                If IsDBNull(ProcessoDT.Rows(0)("ATD").ToString()) = False Then
                    If ltempDT.Rows(0)("dt_conclusao").ToString() = ProcessoDT.Rows(0)("ATD").ToString() Then
                        IntDias = 0
                    Else
                        IntDias = 1
                    End If
                Else
                    IntDias = 1
                End If
            End If
            ActPlaceOfReceiptDate = "<Status>" & vbCrLf
            ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "<StatusType type='ActPlaceOfReceiptDate'/>" & vbCrLf

            If IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True Then
                ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "<StatusDate></StatusDate>" & vbCrLf
            Else
                ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "<StatusDate>" & VB6.Format(CDate(ltempDT.Rows(0)("dt_conclusao").ToString()).AddDays(IntDias), "yyyymmdd") & "</StatusDate>" & vbCrLf
            End If

            ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "</Status>"


            If IsDBNull(ltempDT.Rows(0)("dt_previsao").ToString()) = False Then
                ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "<Status>" & vbCrLf
                ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "<StatusType type='EstPlaceOfReceiptDate'/>" & vbCrLf

                ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_previsao")) = True, "", CDate(ltempDT.Rows(0)("dt_previsao").ToString()).AddDays(IntDias)), "yyyymmdd") & "</StatusDate>" & vbCrLf
                ActPlaceOfReceiptDate = ActPlaceOfReceiptDate & "</Status>"
            End If

        End If


    End Function



    Private Function ActBookingConfirmationDate() As String

        Dim ltempDT As New Data.DataTable

        ActBookingConfirmationDate = ""

        If CBool(UCase(CStr(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM"))) Then
            StrSql = "select dt_conclusao from tarefas_processos with(nolock) where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=5"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                    ActBookingConfirmationDate = "<Status>" & vbCrLf
                    ActBookingConfirmationDate = ActBookingConfirmationDate & "<StatusType type='ActBookingConfirmationDate'/>" & vbCrLf

                    ActBookingConfirmationDate = ActBookingConfirmationDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    ActBookingConfirmationDate = ActBookingConfirmationDate & "</Status>"
                End If
            End If
        End If

    End Function
    Private Function ActDocumentDistributionSentDate() As String

        Dim ltempDT As New Data.DataTable

        ActDocumentDistributionSentDate = ""

        If CBool(UCase(CStr(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM"))) Then
            StrSql = "select dt_conclusao from tarefas_processos with(nolock)  where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=12"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                    ActDocumentDistributionSentDate = "<Status>" & vbCrLf
                    ActDocumentDistributionSentDate = ActDocumentDistributionSentDate & "<StatusType type='ActDocumentDistributionSentDate'/>" & vbCrLf

                    ActDocumentDistributionSentDate = ActDocumentDistributionSentDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    ActDocumentDistributionSentDate = ActDocumentDistributionSentDate & "</Status>"
                End If
            End If
        End If

        If CBool(UCase(CStr(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EO"))) Then
            StrSql = "select dt_conclusao from tarefas_processos with(nolock) where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=12"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                    ActDocumentDistributionSentDate = "<Status>" & vbCrLf
                    ActDocumentDistributionSentDate = ActDocumentDistributionSentDate & "<StatusType type='DocDistDate'/>" & vbCrLf

                    ActDocumentDistributionSentDate = ActDocumentDistributionSentDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    ActDocumentDistributionSentDate = ActDocumentDistributionSentDate & "</Status>"
                End If
            End If
        End If


    End Function



    Private Function BillofLadingRetreivedDate() As String

        Dim ltempDT As New Data.DataTable

        BillofLadingRetreivedDate = ""

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2)) = "EM" Then
            StrSql = "select dt_conclusao from tarefas_processos with(nolock)  where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=66"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("dt_conclusao").ToString()) = False Then
                    BillofLadingRetreivedDate = "<Status>" & vbCrLf
                    BillofLadingRetreivedDate = BillofLadingRetreivedDate & "<StatusType type='BillofLadingRetreivedDate'/>" & vbCrLf

                    BillofLadingRetreivedDate = BillofLadingRetreivedDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    BillofLadingRetreivedDate = BillofLadingRetreivedDate & "</Status>"
                End If
            End If
        End If

    End Function

    Private Function TagsATDM(ByRef StrTag As String) As String

        Dim ltempDT As New Data.DataTable

        TagsATDM = ""


        If IsDBNull(ProcessoDT.Rows(0)("ATD").ToString()) = False Then
            TagsATDM = "<Status>" & vbCrLf
            TagsATDM = TagsATDM & "<StatusType type='" & StrTag & "'/>" & vbCrLf

            TagsATDM = TagsATDM & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            TagsATDM = TagsATDM & "</Status>"
        End If


    End Function


    Private Function EstPortOfExitDate() As String

        Dim ltempDT As New Data.DataTable

        EstPortOfExitDate = ""

        If UCase(Mid(ProcessoDT.Rows(0)("processo").ToString(), 2, 1)) = "M" Then
            EstPortOfExitDate = "<Status>" & vbCrLf
            EstPortOfExitDate = EstPortOfExitDate & "<StatusType type='EstPortOfExitDate'/>" & vbCrLf

            EstPortOfExitDate = EstPortOfExitDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            EstPortOfExitDate = EstPortOfExitDate & "</Status>"
        End If


    End Function


    Private Function DateSailingConfirmed() As String

        Dim ltempDT As New Data.DataTable

        DateSailingConfirmed = ""


        If IsDBNull(ProcessoDT.Rows(0)("ATD").ToString()) = False Then
            DateSailingConfirmed = "<Status>" & vbCrLf
            DateSailingConfirmed = DateSailingConfirmed & "<StatusType type='DateSailingConfirmed '/>" & vbCrLf

            DateSailingConfirmed = DateSailingConfirmed & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            DateSailingConfirmed = DateSailingConfirmed & "</Status>"
        End If

    End Function


    Private Function EstCityOfDischargeArrivalDate() As String

        Dim ltempDT As New Data.DataTable

        EstCityOfDischargeArrivalDate = ""

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then Exit Function
        'Alterado em 22/03/2011


        If IsDBNull(ProcessoDT.Rows(0)("ETA").ToString()) = False Then
            EstCityOfDischargeArrivalDate = "<Status>" & vbCrLf
            EstCityOfDischargeArrivalDate = EstCityOfDischargeArrivalDate & "<StatusType type='EstCityOfDischargeArrivalDate '/>" & vbCrLf

            EstCityOfDischargeArrivalDate = EstCityOfDischargeArrivalDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            EstCityOfDischargeArrivalDate = EstCityOfDischargeArrivalDate & "</Status>"
        End If

    End Function

    Private Function RequestedETADestinationDate() As String

        Dim ltempDT As New Data.DataTable

        RequestedETADestinationDate = ""


        If IsDBNull(ProcessoDT.Rows(0)("ETA").ToString()) = False Then
            RequestedETADestinationDate = "<Status>" & vbCrLf
            RequestedETADestinationDate = RequestedETADestinationDate & "<StatusType type='RequestedETADestinationDate'/>" & vbCrLf

            RequestedETADestinationDate = RequestedETADestinationDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            RequestedETADestinationDate = RequestedETADestinationDate & "</Status>"
        End If

    End Function

    Private Function EstPortOfArrivalDate() As String


        EstPortOfArrivalDate = ""


        If IsDBNull(ProcessoDT.Rows(0)("ETA").ToString()) = False Then
            EstPortOfArrivalDate = "<Status>" & vbCrLf
            EstPortOfArrivalDate = EstPortOfArrivalDate & "<StatusType type='EstPortOfArrivalDate'/>" & vbCrLf

            EstPortOfArrivalDate = EstPortOfArrivalDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            EstPortOfArrivalDate = EstPortOfArrivalDate & "</Status>"
        End If

    End Function




    Private Function ActPortOfExitDate() As String

        Dim ltempDT As New Data.DataTable

        ActPortOfExitDate = ""


        If IsDBNull(ProcessoDT.Rows(0)("ATD").ToString()) = False Then
            ActPortOfExitDate = "<Status>" & vbCrLf
            ActPortOfExitDate = ActPortOfExitDate & "<StatusType type='ActPortOfExitDate '/>" & vbCrLf

            ActPortOfExitDate = ActPortOfExitDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ActPortOfExitDate = ActPortOfExitDate & "</Status>"
        End If

    End Function




    Private Function DocsRcvdDateEM() As String

        Dim ltempDT As New Data.DataTable

        DocsRcvdDateEM = ""

        If CBool(UCase(CStr(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM"))) Then
            StrSql = "select dt_conclusao from tarefas_processos with(nolock)  where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "' and id_task=66"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)


            If ltempDT.Rows.Count > 0 Then

                If IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = False Then
                    DocsRcvdDateEM = "<Status>" & vbCrLf
                    DocsRcvdDateEM = DocsRcvdDateEM & "<StatusType type='DocsRcvdDate'/>" & vbCrLf

                    DocsRcvdDateEM = DocsRcvdDateEM & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", CDate(ltempDT.Rows(0)("dt_conclusao").ToString()).AddDays(-1)), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    DocsRcvdDateEM = DocsRcvdDateEM & "</Status>"
                End If
            End If
        End If

    End Function




    Private Function EstimatedPlaceofReceiptDate() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select data from pedido PD  with(nolock) " & " Join Data_Pedidos DP with(nolock)  on DP.cd_pedido=PD.cd_pedido and id_ref=6 " & " join Pedido_Ship PS with(nolock)  on PS.cd_pedido=PD.cd_pedido " & " Where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            EstimatedPlaceofReceiptDate = ""
            Exit Function
        End If

        EstimatedPlaceofReceiptDate = "<Status>" & vbCrLf
        EstimatedPlaceofReceiptDate = EstimatedPlaceofReceiptDate & "<StatusType type='EstimatedPlaceofReceiptDate'/>" & vbCrLf

        EstimatedPlaceofReceiptDate = EstimatedPlaceofReceiptDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("Data")) = True, "", ltempDT.Rows(0)("Data").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        EstimatedPlaceofReceiptDate = EstimatedPlaceofReceiptDate & "</Status>"



    End Function

    Private Function ActDeliveryDate() As String

        Dim ltempDT As New Data.DataTable

        'Edited by Anderson Oliveira - 13.10.2011
        If ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDP" Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "DDU" Then

            ActDeliveryDate = "<Status>" & vbCrLf
            ActDeliveryDate = ActDeliveryDate & "<StatusType type='ActPlaceOfDeliveryDate'/>" & vbCrLf

            If IsDBNull(ProcessoDT.Rows(0)("ATA")) = True Then
                ActDeliveryDate = ActDeliveryDate & "<StatusDate></StatusDate>" & vbCrLf
            Else
                ActDeliveryDate = ActDeliveryDate & "<StatusDate>" & VB6.Format(CDate(ProcessoDT.Rows(0)("ATA").ToString()).AddDays(5), "yyyymmdd") & "</StatusDate>" & vbCrLf
            End If
            ActDeliveryDate = ActDeliveryDate & "</Status>"
        End If

    End Function
    Private Function EstimatedPortofEntryDate() As String

        EstimatedPortofEntryDate = ""

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) <> "I" Then Exit Function

        'Agencia

        If IsDBNull(ProcessoDT.Rows(0)("ETA")) = True Then
            EstimatedPortofEntryDate = ""
            Exit Function
        End If

        EstimatedPortofEntryDate = "<Status>" & vbCrLf
        EstimatedPortofEntryDate = EstimatedPortofEntryDate & "<StatusType type='EstimatedPortofEntryDate'/>" & vbCrLf

        EstimatedPortofEntryDate = EstimatedPortofEntryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        EstimatedPortofEntryDate = EstimatedPortofEntryDate & "</Status>"

    End Function
    'Private Function EstimatedAirportofEntryDate() As String


    '    If IsDBNull(ProcessoDT.Rows(0)("ETA")) = True Then
    '        EstimatedAirportofEntryDate = ""
    '        Exit Function
    '    End If

    '    EstimatedAirportofEntryDate = "<Status>" & vbCrLf
    '    EstimatedAirportofEntryDate = EstimatedAirportofEntryDate & "<StatusType type='EstimatedAirportofEntryDate'/>" & vbCrLf

    '    EstimatedAirportofEntryDate = EstimatedAirportofEntryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
    '    EstimatedAirportofEntryDate = EstimatedAirportofEntryDate & "</Status>"

    'End Function
    Private Function ActualPortofEntryDate() As String

        ActualPortofEntryDate = ""
        Exit Function 'desabilitado por Anderson 04/07/2012

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) <> "I" Then Exit Function

        'Presenca de Carga

        If IsDBNull(ProcessoDT.Rows(0)("ATA")) = True Then
            ActualPortofEntryDate = ""
            Exit Function
        End If

        ActualPortofEntryDate = "<Status>" & vbCrLf
        ActualPortofEntryDate = ActualPortofEntryDate & "<StatusType type='ActualPortofEntryDate'/>" & vbCrLf

        ActualPortofEntryDate = ActualPortofEntryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATA")) = True, "", ProcessoDT.Rows(0)("ATA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ActualPortofEntryDate = ActualPortofEntryDate & "</Status>"


    End Function

    Private Function ActPortOfArrivalDate() As String

        'Presenca de Carga

        If IsDBNull(ProcessoDT.Rows(0)("ATA")) = True Then
            ActPortOfArrivalDate = ""
            Exit Function
        End If

        ActPortOfArrivalDate = "<Status>" & vbCrLf
        ActPortOfArrivalDate = ActPortOfArrivalDate & "<StatusType type='ActPortOfArrivalDate'/>" & vbCrLf

        ActPortOfArrivalDate = ActPortOfArrivalDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATA")) = True, "", ProcessoDT.Rows(0)("ATA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ActPortOfArrivalDate = ActPortOfArrivalDate & "</Status>"


    End Function


    Private Function ActCityOfExitDate() As String


        If IsDBNull(ProcessoDT.Rows(0)("ATD")) = True Then
            ActCityOfExitDate = ""
            Exit Function
        End If

        ActCityOfExitDate = "<Status>" & vbCrLf
        ActCityOfExitDate = ActCityOfExitDate & "<StatusType type='ActCityOfExitDate'/>" & vbCrLf

        ActCityOfExitDate = ActCityOfExitDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ActCityOfExitDate = ActCityOfExitDate & "</Status>"


    End Function
    Private Function ActDestinationDeliveryDate() As String

        Dim ltempDT As New Data.DataTable

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then Exit Function
        'Altera��o feita em 22/03/2011
        StrSql = "select Dt_Conclusao,dt_previsao from tarefas_processos with(nolock)  where id_task=13 and num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "' and dt_conclusao is not null"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "<Status>" & vbCrLf
            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "<StatusType type='ActDestinationDeliveryDate'/>" & vbCrLf

            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_conclusao")) = True, "", ltempDT.Rows(0)("dt_conclusao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "</Status>"

            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "<Status>" & vbCrLf
            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "<StatusType type='EstDestinationDeliveryDate'/>" & vbCrLf

            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_previsao")) = True, "", ltempDT.Rows(0)("dt_previsao").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
            ActDestinationDeliveryDate = ActDestinationDeliveryDate & "</Status>"

        End If


    End Function

    Private Function ActCityOfOriginDate() As String


        If IsDBNull(ProcessoDT.Rows(0)("ATD")) = True Then
            ActCityOfOriginDate = ""
            Exit Function
        End If

        ActCityOfOriginDate = "<Status>" & vbCrLf
        ActCityOfOriginDate = ActCityOfOriginDate & "<StatusType type='ActCityOfOriginDate'/>" & vbCrLf

        ActCityOfOriginDate = ActCityOfOriginDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ATD")) = True, "", ProcessoDT.Rows(0)("ATD").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        ActCityOfOriginDate = ActCityOfOriginDate & "</Status>"


    End Function


    Private Function BLActionDate() As String

        Dim ltempDT As New Data.DataTable

        BLActionDate = ""
        'Desabilitado em 23/03/2011
        Exit Function

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "EM" Then
            BLActionDate = ""
            Exit Function
        End If

        StrSql = "select Dt_BL_Lem from llp_Exp_mar with(nolock) where num_proc_lem='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        BLActionDate = ""

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_bl_lem")) = True Then
                BLActionDate = ""
                Exit Function
            End If
        Else
            Exit Function
        End If
        BLActionDate = "<Status>" & vbCrLf
        BLActionDate = BLActionDate & "<StatusType type='BillofLadingActionDate'/>" & vbCrLf

        BLActionDate = BLActionDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl_lem")) = True, "", ltempDT.Rows(0)("dt_bl_lem").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        BLActionDate = BLActionDate & "</Status>"


    End Function


    Private Function MbolMawbIssueDate() As String

        Dim ltempDT As New Data.DataTable

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "EM" Then
            MbolMawbIssueDate = ""
            Exit Function
        End If

        StrSql = "select Dt_BL_Lem from llp_Exp_mar with(nolock)  where num_proc_lem='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        MbolMawbIssueDate = ""

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("dt_bl_lem")) = True Then
                MbolMawbIssueDate = ""
                Exit Function
            End If
        Else
            Exit Function
        End If
        MbolMawbIssueDate = "<Status>" & vbCrLf
        MbolMawbIssueDate = MbolMawbIssueDate & "<StatusType type='BillofLadingActionDate'/>" & vbCrLf

        MbolMawbIssueDate = MbolMawbIssueDate & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl_lem")) = True, "", ltempDT.Rows(0)("dt_bl_lem").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        MbolMawbIssueDate = MbolMawbIssueDate & "</Status>"


    End Function


    Private Function BOLActionDate() As String

        Dim ltempDT As New Data.DataTable
        Dim strDados As String

        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EM"
                StrSql = "select Dt_BL_Lem from llp_Exp_mar with(nolock) where num_proc_lem='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl_lem")) = True, "", ltempDT.Rows(0)("dt_bl_lem").ToString()), "yyyymmdd")
                End If
            Case "EA"
                StrSql = "select Isnull(Dt_Impres_Lea,atd_lea) DT_BL from llp_exp_aer with(nolock)  where num_proc_lea='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl")) = True, "", ltempDT.Rows(0)("dt_bl").ToString()), "yyyymmdd")
                End If
            Case "EO"
                StrSql = "select ATD_LEO DT_BL from llp_exp_out with(nolock)  where num_proc_leo='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl")) = True, "", ltempDT.Rows(0)("dt_bl").ToString()), "yyyymmdd")
                End If
            Case "IM"
                StrSql = "select ATD_LIM DT_BL from llp_Imp_Mar with(nolock) where num_proc_lim='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl")) = True, "", ltempDT.Rows(0)("dt_bl").ToString()), "yyyymmdd")
                End If
            Case "IA"
                StrSql = "select ATD_LIA DT_BL from llp_Imp_Aer with(nolock) where num_proc_lia='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl")) = True, "", ltempDT.Rows(0)("dt_bl").ToString()), "yyyymmdd")
                End If
            Case "IO"
                StrSql = "select ATD_LIO DT_BL from llp_Imp_out with(nolock) where num_proc_lio='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = VB6.Format(IIf(IsDBNull(ltempDT.Rows(0)("dt_bl")) = True, "", ltempDT.Rows(0)("dt_bl").ToString()), "yyyymmdd")
                End If


        End Select


        BOLActionDate = ""

        BOLActionDate = "<Status>" & vbCrLf
        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Or VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EA" Then
            BOLActionDate = BOLActionDate & "<StatusType type='BolAwbIssueDate'/>" & vbCrLf
        Else
            BOLActionDate = BOLActionDate & "<StatusType type='BolAwbIssueDate'/>" & vbCrLf
        End If
        BOLActionDate = BOLActionDate & "<StatusDate>" & strDados & "</StatusDate>" & vbCrLf
        BOLActionDate = BOLActionDate & "</Status>"


    End Function


    Private Function ETA() As String

        ETA = "<Status>" & vbCrLf
        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                ETA = ETA & "<StatusType type='EstimatedPortofDischargeDate'/>" & vbCrLf

                ETA = ETA & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("ETA")) = True, "", ProcessoDT.Rows(0)("ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
                ETA = ETA & "</Status>"
            Case Else
                ETA = ""

        End Select

    End Function
    Private Function Original_ETA() As String

        Original_ETA = "<Status>" & vbCrLf
        Select Case UCase(VB.Right(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2), 1))
            Case "M"
                Original_ETA = Original_ETA & "<StatusType type='OriginalETADate'/>" & vbCrLf
            Case "A"
                Original_ETA = Original_ETA & "<StatusType type='OriginalETADate'/>" & vbCrLf
            Case "O"
                Original_ETA = Original_ETA & "<StatusType type='OriginalETADate'/>" & vbCrLf
        End Select

        Original_ETA = Original_ETA & "<StatusDate>" & VB6.Format(IIf(IsDBNull(ProcessoDT.Rows(0)("Original_ETA")) = True, "", ProcessoDT.Rows(0)("Original_ETA").ToString()), "yyyymmdd") & "</StatusDate>" & vbCrLf
        Original_ETA = Original_ETA & "</Status>"

    End Function


    Private Function Order_Date() As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Order_Date = ""

        If ltempDT.Rows.Count > 0 Then
            Order_Date = "<Status>" & vbCrLf
            Order_Date = Order_Date & "<StatusType type='OrderReceiveDate'/>" & vbCrLf
            Order_Date = Order_Date & "<StatusDate>" & CStr(VB6.Format(ltempDT.Rows(0)("dt_pedido").ToString(), "yyyymmdd")) & "</StatusDate>" & vbCrLf
            Order_Date = Order_Date & "</Status>"
        End If



    End Function
    Private Function Insercao() As String

        Insercao = "<Status>" & vbCrLf
        Insercao = Insercao & "<StatusType type='LoggedDate'/>" & vbCrLf
        Insercao = Insercao & "<StatusDate>" & VB6.Format(ProcessoDT.Rows(0)("dt_emis").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
        Insercao = Insercao & "</Status>"

    End Function
    Private Function FileCreationDate() As String

        FileCreationDate = "<Status>" & vbCrLf
        FileCreationDate = FileCreationDate & "<StatusType type='FileCreationDate'/>" & vbCrLf
        FileCreationDate = FileCreationDate & "<StatusDate>" & VB6.Format(ProcessoDT.Rows(0)("dt_emis").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
        FileCreationDate = FileCreationDate & "</Status>"

    End Function
    Private Function BDPBillingInvoiceDateActual() As String

        Dim ltempDT As New Data.DataTable
        If StrPais <> "Argentina" Then
            StrSql = "select FatDtVenc dt from fatura where left(fatcod,16)='" & ProcessoDT.Rows(0)("processo").ToString() & "' and cd_pes='" & IIf(UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) = "I", ProcessoDT.Rows(0)("cd_consig").ToString(), ProcessoDT.Rows(0)("processo").ToString()) & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Else

            StrSql = "select Top 1 F.Dt_Fatura dt  from Fatura_Arg F join Fatura_ARG_Det FD on f.ID_Fat=fd.ID_Fat where F.Status<>'D' AND left(Num_Proc,16)='" & strProcesso & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        End If
        For Each lTempDR As DataRow In ltempDT.Rows

            BDPBillingInvoiceDateActual = "<Status>" & vbCrLf
            BDPBillingInvoiceDateActual = BDPBillingInvoiceDateActual & "<StatusType type='BDPBillingInvoiceDateActual'/>" & vbCrLf
            BDPBillingInvoiceDateActual = BDPBillingInvoiceDateActual & "<StatusDate>" & IIf(IsDBNull(lTempDR.Item("dt")) = True, "", VB6.Format(lTempDR.Item("dt").ToString(), "yyyymmdd")) & "</StatusDate>" & vbCrLf
            BDPBillingInvoiceDateActual = BDPBillingInvoiceDateActual & "<StatusTime></StatusTime>" & vbCrLf
            BDPBillingInvoiceDateActual = BDPBillingInvoiceDateActual & "</Status>"

        Next


    End Function

    Private Function LastModifiedByDate() As String

        LastModifiedByDate = "<Status>" & vbCrLf
        LastModifiedByDate = LastModifiedByDate & "<StatusType type='LastModifiedByDate'/>" & vbCrLf
        LastModifiedByDate = LastModifiedByDate & "<StatusDate>" & VB6.Format(Now, "yyyymmdd") & "</StatusDate>" & vbCrLf
        LastModifiedByDate = LastModifiedByDate & "</Status>"

    End Function



    Private Function Doc() As String

        Doc = ""


        If IsDBNull(ProcessoDT.Rows(0)("ATA").ToString()) = False Then
            Doc = "<Status>" & vbCrLf
            Doc = Doc & "<StatusType type='DocsRcvdDate'/>" & vbCrLf
            Doc = Doc & "<StatusDate>" & VB6.Format(ProcessoDT.Rows(0)("ATA").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
            Doc = Doc & "</Status>"
        End If

    End Function
    Private Function Doc_Aereo() As String

        Doc_Aereo = ""

        If ProcessoDT.Rows(0)("ATA").ToString().Length > 0 Then

            Doc_Aereo = "<Status>" & vbCrLf
            Doc_Aereo = Doc_Aereo & "<StatusType type='DocsRcvdDate'/>" & vbCrLf
            'Doc_Aereo = Doc_Aereo & "<StatusDate>" & VB6.Format(ProcessoDT.Rows(0)("ATA").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
            Doc_Aereo = Doc_Aereo + "<StatusDate>" + Convert.ToDateTime(ProcessoDT.Rows(0)("ATA").ToString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
            Doc_Aereo = Doc_Aereo & "</Status>"

        End If
    End Function
    Private Function ContainerProduto(ByRef strProcesso As String, ByRef strPRoduto As String, ByRef strLote As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spSmartProdutoContainer_INT '" & strProcesso & "','" & strPRoduto & "'"
        StrSql = "spSmartProdutoContainerLote_INT '" & strProcesso & "','" & strPRoduto & "','" & strLote & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        ContainerProduto = ""
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows

            ContainerProduto = ContainerProduto & "<ProductEquipment>"
            ContainerProduto = ContainerProduto & "<Prod-EquipNo>" + lTempDR.Item("num_cont_em").ToString() + "</Prod-EquipNo>"
            ContainerProduto = ContainerProduto & "<Prod-EquipSealNo>" & CStr(lTempDR.Item("num_lacre_em").ToString()) & "</Prod-EquipSealNo>"
            ContainerProduto = ContainerProduto & "<Prod-EquipType>" & CStr(lTempDR.Item("Container").ToString()) & "</Prod-EquipType>"
            ContainerProduto = ContainerProduto & "<Prod-EquipTypeCode>" & CStr(lTempDR.Item("cd_smart").ToString()) & "</Prod-EquipTypeCode>"
            ContainerProduto = ContainerProduto & "<Prod-EquipSize>" & CStr(lTempDR.Item("cd_cc_ofc").ToString()) & "</Prod-EquipSize>"
            ContainerProduto = ContainerProduto & "</ProductEquipment>"
        Next

    End Function


    'Private Function Produto(ByRef strProcesso As String) As String

    '    Dim ltempDT As New Data.DataTable

    '    Select Case UCase(VB.Left(strProcesso, 2))
    '        Case "EM"
    '            StrSql = "select prod_hem Produto from prd_hou_exp_mar with(nolock) where num_proc_hem='" & strProcesso & "'"
    '        Case "EA"
    '            StrSql = "select prod_hea Produto from prd_hou_exp_aer with(nolock) where num_proc_hea='" & strProcesso & "'"
    '    End Select
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)


    '    Produto = "<ProductDetail action='Add'>" & vbCrLf
    '    Produto = Produto & "<InvoiceDesc></InvoiceDesc>"
    '    Produto = Produto & "<LineItemNo>1</LineItemNo>" & vbCrLf

    '    If VB.Left(strProcesso, 2) = "EM" Then
    '        If ltempDT.Rows.Count = 0 Then
    '            Produto = Produto & "<BrandName>" & Upper_Case(Produtos_Brand) & "</BrandName>" & vbCrLf
    '            Produto = Produto & "<BLDesc></BLDesc>" & vbCrLf
    '        Else
    '            Produto = Produto & "<BrandName>" & Upper_Case(Produtos_Brand) & "</BrandName>" & vbCrLf

    '            Produto = Produto & "<BLDesc>" & Upper_Case(IIf(IsDBNull(Replace(ltempDT.Rows(0)("Produto").ToString(), vbCrLf, " ")) = True, "", Replace(ltempDT.Rows(0)("Produto").ToString(), vbCrLf, "  "))) & "</BLDesc>" & vbCrLf
    '        End If
    '    Else
    '        If ltempDT.Rows.Count = 0 Then
    '            Produto = Produto & "<BrandName>" & "" & "</BrandName>" & vbCrLf
    '        Else

    '            Produto = Produto & "<BrandName>" & Upper_Case(IIf(IsDBNull(Replace(ltempDT.Rows(0)("Produto").ToString(), vbCrLf, " ")) = True, "", Replace(ltempDT.Rows(0)("Produto").ToString(), vbCrLf, "  "))) & "</BrandName>" & vbCrLf
    '        End If
    '    End If
    '    Produto = Produto & "<BilledQuantity>" & CStr(Replace(ProcessoDT.Rows(0)("peso_liquido").ToString(), ",", ".")) & "</BilledQuantity>" & vbCrLf
    '    Produto = Produto & "<BilledQuantityUnit>KG</BilledQuantityUnit>" & vbCrLf
    '    Produto = Produto & "<NoOfPkgs>" & CStr(ProcessoDT.Rows(0)("qtd_tot_vol").ToString()) & "</NoOfPkgs>" & vbCrLf
    '    Produto = Produto & "<TypePkgDesc></TypePkgDesc>" & vbCrLf
    '    Produto = Produto & "<Measurements type='GrsWtKgs'>" & vbCrLf
    '    Produto = Produto & "<MeasurementValue>" & CStr(Replace(ProcessoDT.Rows(0)("Peso_Bruto").ToString(), ",", ".")) & "</MeasurementValue>" & vbCrLf
    '    Produto = Produto & "</Measurements>" & vbCrLf
    '    Produto = Produto & "<Measurements type='NetWtKgs'>" & vbCrLf
    '    Produto = Produto & "<MeasurementValue>" & CStr(Replace(ProcessoDT.Rows(0)("peso_liquido").ToString(), ",", ".")) & "</MeasurementValue>" & vbCrLf
    '    Produto = Produto & "</Measurements>" & vbCrLf
    '    Produto = Produto & "<Measurements type='VolumeCM'>" & vbCrLf
    '    Produto = Produto & "<MeasurementValue>" & CStr(Replace(ProcessoDT.Rows(0)("Vol_Tot").ToString(), ",", ".")) & "</MeasurementValue>" & vbCrLf
    '    Produto = Produto & "</Measurements>" & vbCrLf
    '    Produto = Produto & "</ProductDetail>"


    'End Function

    Private Function Abre_Detalhe() As String

        Abre_Detalhe = "<Detail>"

    End Function

    Private Function Fecha_Detalhe() As String

        Fecha_Detalhe = "</Detail>"

    End Function
    'Private Function Invoice() As String

    '    Dim ltempDT As New Data.DataTable
    '    Dim fltTotalInvoice As Decimal
    '    Dim vlr_frete As Decimal

    '    Dim lCabecalho As New Data.DataTable
    '    Dim StrDetalhe As String
    '    Dim strMoeda As String
    '    Dim intSeq As Short

    '    StrSql = "select dbo.fBusca_TipoDocCliente('D','" + ProcessoDT.Rows(0)("processo").ToString() + "',1) Data"
    '    lCabecalho = sqlCnn.BuscaInformacoes(StrSql)

    '    glbfltTotalInvoice = 0

    '    StrSql = "spINT_PEDIDO '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)

    '    Invoice = ""

    '    If ltempDT.Rows.Count = 0 Then Exit Function


    '    Invoice = "<CommercialInvoice>" & vbCrLf
    '    Invoice = Invoice & "<InvoiceNumber>" & Invoice_STR() & "</InvoiceNumber>" & vbCrLf



    '    If IsDBNull(ProcessoDT.Rows(0)("cd_tp_oper")) = True Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "CSR" Then

    '        Invoice = Invoice & "<TermsofSaleCode>" & "CPT" & "</TermsofSaleCode>" & vbCrLf
    '        'Invoice = Invoice & "<TermsofSaleDesc>" & Incoterm("CPT") & "</TermsofSaleDesc>" & vbCrLf
    '        Invoice = Invoice & "<TermsofSaleDesc>" & "CPT" & "</TermsofSaleDesc>" & vbCrLf
    '        Invoice = Invoice & "<FinalTermsofSaleCode>" & "CPT" & "</FinalTermsofSaleCode>" & vbCrLf
    '        'Invoice = Invoice & "<FinalTermsofSaleDesc>" & Incoterm("CPT") & "</FinalTermsofSaleDesc>" & vbCrLf
    '        Invoice = Invoice & "<FinalTermsofSaleDesc>" & "CPT" & "</FinalTermsofSaleDesc>" & vbCrLf

    '        Invoice = Invoice & "<TermsofPaymentCode>" & CStr(ltempDT.Rows(0)("cd_termo").ToString()) & "</TermsofPaymentCode>" & vbCrLf
    '        Invoice = Invoice & "<TermsofPaymentDescription>" + ltempDT.Rows(0)("termo").ToString() + "</TermsofPaymentDescription>"

    '    Else
    '        Invoice = Invoice & "<TermsofSaleCode>" + ProcessoDT.Rows(0)("cd_tp_oper").ToString() + "</TermsofSaleCode>" + vbCrLf
    '        'Invoice = Invoice & "<TermsofSaleDesc>" & Incoterm(ProcessoDT.Rows(0)("cd_tp_oper").toString()) & "</TermsofSaleDesc>" & vbCrLf
    '        Invoice = Invoice & "<TermsofSaleDesc>" & ProcessoDT.Rows(0)("cd_tp_oper").ToString() & "</TermsofSaleDesc>" & vbCrLf
    '        Invoice = Invoice & "<FinalTermsofSaleCode>" + ProcessoDT.Rows(0)("cd_tp_oper").ToString() + "</FinalTermsofSaleCode>" + vbCrLf
    '        'Invoice = Invoice & "<FinalTermsofSaleDesc>" & Incoterm(ProcessoDT.Rows(0)("cd_tp_oper").toString()) & "</FinalTermsofSaleDesc>" & vbCrLf
    '        Invoice = Invoice & "<FinalTermsofSaleDesc>" & ProcessoDT.Rows(0)("cd_tp_oper").ToString() & "</FinalTermsofSaleDesc>" & vbCrLf
    '        Dim Cd_Termo As String
    '        Cd_Termo = IIf(IsDBNull(ltempDT.Rows(0)("cd_termo").ToString()), "", CStr(ltempDT.Rows(0)("cd_termo").ToString()))
    '        Dim Termo As String
    '        Termo = IIf(IsDBNull(ltempDT.Rows(0)("termo").ToString()), "", CStr(ltempDT.Rows(0)("termo").ToString()))
    '        Invoice = Invoice & "<TermsofPaymentCode>" & Cd_Termo & "</TermsofPaymentCode>" & vbCrLf
    '        Invoice = Invoice & "<TermsofPaymentDescription>" + Termo + "</TermsofPaymentDescription>"

    '    End If

    '    If lCabecalho.Rows.Count > 0 Then
    '        Invoice = Invoice & "<InvoiceAmount>" & "valor_invoice" & "</InvoiceAmount>"
    '        Invoice = Invoice & "<CurrencyCode>" + ltempDT.Rows(0)("cd_Tp_moeda").ToString() + "</CurrencyCode>"
    '        Invoice = Invoice & "<CIDate>" & VB6.Format(VB.Left(lCabecalho.Rows(0)("Data").ToString(), 10), "yyyyMMdd") & "</CIDate>"

    '    End If



    '    StrDetalhe = ""
    '    fltTotalInvoice = 0
    '    intSeq = 1
    '    For Each lTempDR As DataRow In ltempDT.Rows
    '        strMoeda = UCase(lTempDR.Item("cd_Tp_moeda").ToString())
    '        fltTotalInvoice = fltTotalInvoice + (lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString())
    '        StrDetalhe = StrDetalhe & "<CIProductDetail action='Add'>"
    '        StrDetalhe = StrDetalhe & "<LineItemNo>" & CStr(intSeq) & "</LineItemNo>"
    '        StrDetalhe = StrDetalhe & "<ProductCode>" + lTempDR.Item("Gmid").ToString() + "</ProductCode>"
    '        StrDetalhe = StrDetalhe & "<BrandName><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></BrandName>"
    '        StrDetalhe = StrDetalhe & "<InvoiceDesc><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></InvoiceDesc>"
    '        StrDetalhe = StrDetalhe & "<BilledQuantity>" & Replace(CStr(VB6.Format(lTempDR.Item("quantidade").ToString(), "0.00")), ",", ".") & "</BilledQuantity>" & vbCrLf
    '        StrDetalhe = StrDetalhe & "<BilledQuantityUnit>" & Upper_Case(lTempDR.Item("tipo_unid").ToString()) & "</BilledQuantityUnit>"
    '        StrDetalhe = StrDetalhe & "<Price>" & Replace(CStr(VB6.Format(lTempDR.Item("preco_unit").ToString(), "0.00")), ",", ".") & "</Price>" & vbCrLf
    '        StrDetalhe = StrDetalhe & "<PriceCurrency>" & UCase(lTempDR.Item("cd_Tp_moeda").ToString()) & "</PriceCurrency>"
    '        StrDetalhe = StrDetalhe & "<Amount>" & Replace(CStr(VB6.Format(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString(), "0.00")), ",", ".") & "</Amount>"
    '        StrDetalhe = StrDetalhe & "<AmountCurrency>" & UCase(lTempDR.Item("cd_Tp_moeda").ToString()) & "</AmountCurrency>"

    '        StrDetalhe = StrDetalhe & "</CIProductDetail>"

    '        intSeq = intSeq + 1

    '    Next

    '    If ProcessoDT.Rows(0)("vlr_frete").ToString().Length = 0 Then
    '        vlr_frete = 0
    '    Else
    '        vlr_frete = ProcessoDT.Rows(0)("vlr_frete").ToString()
    '    End If

    '    Invoice = Replace(Invoice, "valor_invoice", Replace(CStr(fltTotalInvoice), ",", "."))
    '    If vlr_frete < fltTotalInvoice Then
    '        fltTotalInvoice = fltTotalInvoice - vlr_frete
    '    End If
    '    Invoice = Invoice & "<FOBAmount>" & Replace(CStr(fltTotalInvoice), ",", ".") & "</FOBAmount>"
    '    glbfltTotalInvoice = fltTotalInvoice
    '    Invoice = Invoice & "<FOBCurrency>" & strMoeda & "</FOBCurrency>"

    '    Invoice = Invoice & "<ChargeInd>" & "N" & "</ChargeInd>" & vbCrLf


    '    Invoice = Invoice & StrDetalhe

    '    Invoice = Invoice & "</CommercialInvoice>"


    'End Function
    Private Function Footer() As String

        Dim PesoBrutof As Decimal
        Dim ltempDT As New Data.DataTable
        Dim qtd_tot_vol As Decimal
        qtd_tot_vol = IIf(IsDBNull(ProcessoDT.Rows(0)("qtd_tot_vol")) = True, 0, ProcessoDT.Rows(0)("qtd_tot_vol").ToString())


        StrSql = "select sum(qtd_Vol_em) Qtd from volume_exp_mar with(nolock) Where num_proc_hem='" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        StrSql = "spVolumesBDPSINT_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        'If IsDBNull(ProcessoDT.Rows(0)("Peso_Bruto").ToString()) = False Then
        'cadu
        If String.IsNullOrEmpty(ProcessoDT.Rows(0)("Peso_Bruto").ToString()) = False Then
            If ProcessoDT.Rows(0)("Peso_Bruto").ToString() <> "0" Then
                PesoBrutof = ProcessoDT.Rows(0)("Peso_Bruto").ToString()
            Else
                PesoBrutof = PesoBruto
            End If
        Else
            PesoBrutof = PesoBruto
        End If


        If PesoBrutof < PesoLiquido Then
            PesoBrutof = PesoLiquido
        End If
        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then
            Footer = "<Footer>" & vbCrLf
            Footer = Footer & "<Measurements item='GrossWeightKilograms'>" & vbCrLf
            Footer = Footer & "<MeasurementValue>" & Replace(CStr(PesoBrutof), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer = Footer & "</Measurements>" & vbCrLf
            Footer = Footer & "</Footer>"

            Footer = Footer & "<Footer>" & vbCrLf

            Footer = Footer & "<Measurements item='GrossWeightPounds'>" & vbCrLf
            Footer = Footer & "<MeasurementValue>" & Replace(CStr(PesoBrutof * 2.2046), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer = Footer & "</Measurements>" & vbCrLf
            Footer = Footer & "</Footer>"


            Footer = Footer & "<Footer>" & vbCrLf
            Footer = Footer & "<Measurements item='NetWeightKilograms'>" & vbCrLf
            Footer = Footer & "<MeasurementValue>" & Replace(CStr(PesoLiquido), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer = Footer & "</Measurements>" & vbCrLf
            Footer = Footer & "</Footer>"

            Footer = Footer & "<Footer>" & vbCrLf
            Footer = Footer & "<Measurements item='NetWeightPounds'>" & vbCrLf
            Footer = Footer & "<MeasurementValue>" & Replace(CStr(PesoLiquido * 2.2046), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer = Footer & "</Measurements>" & vbCrLf
            Footer = Footer & "</Footer>"

            Footer = Footer & "<Footer>" & vbCrLf
            Footer = Footer & "<Measurements item='VolumeCubicFeet'>" & vbCrLf
            Footer = Footer & "<MeasurementValue>" & Replace(CStr(IIf(IsDBNull(ProcessoDT.Rows(0)("Vol_Tot")) = True, "", ProcessoDT.Rows(0)("Vol_Tot").ToString())), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer = Footer & "</Measurements>" & vbCrLf
            Footer = Footer & "</Footer>"

            Footer = Footer & "<Footer>" & vbCrLf
            Footer = Footer & "<Measurements item='VolumeCubicMeters'>" & vbCrLf
            Footer = Footer & "<MeasurementValue>" & Replace(CStr(qtd_tot_vol), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer = Footer & "</Measurements>" & vbCrLf
            Footer = Footer & "</Footer>"


            If ltempDT.Rows.Count > 0 Then
                Footer = Footer & "<Footer>" & vbCrLf

                Footer = Footer & "<Measurements item='NumberofPalletPackages'>" & vbCrLf

                Footer = Footer & "<MeasurementValue>" & Replace(CStr(IIf(IsDBNull(ltempDT.Rows(0)("qtd")) = True, "", ltempDT.Rows(0)("qtd").ToString())), ",", ".") & "</MeasurementValue>" & vbCrLf
                Footer = Footer & "</Measurements>" & vbCrLf
                Footer = Footer & "</Footer>"


            End If


            'Casos A�reo
            If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "IA" Then

                Footer = "<Footer>" & vbCrLf
                Footer = Footer & "<Measurements item='GrossWeightKilograms'>" & vbCrLf
                Footer = Footer & "<MeasurementValue>" & Replace(CStr(PesoBrutof), ",", ".") & "</MeasurementValue>" & vbCrLf
                Footer = Footer & "</Measurements>" & vbCrLf
                Footer = Footer & "</Footer>"

                Footer = "<Footer>" & vbCrLf
                Footer = Footer & "<Measurements item='GrossWeightKilograms'>" & vbCrLf
                Footer = Footer & "<MeasurementValue>" & Replace(CStr(PesoBrutof), ",", ".") & "</MeasurementValue>" & vbCrLf
                Footer = Footer & "</Measurements>" & vbCrLf
                Footer = Footer & "</Footer>"

            End If


        End If

    End Function
    Private Function Footer_Net() As String

        Dim PesoLiquidoF As Decimal
        Dim qtd_tot_vol As Decimal

        If IsDBNull(PesoLiquido) = True Then
            PesoLiquidoF = ProcessoDT.Rows(0)("peso_liquido").ToString()
        Else
            If PesoLiquido = 0 Then

                PesoLiquidoF = IIf(IsDBNull(ProcessoDT.Rows(0)("peso_liquido")) = True, 0, ProcessoDT.Rows(0)("peso_liquido").ToString())
            Else
                PesoLiquidoF = PesoLiquido
            End If
        End If

        qtd_tot_vol = IIf(IsDBNull(ProcessoDT.Rows(0)("qtd_tot_vol")) = True, 0, ProcessoDT.Rows(0)("qtd_tot_vol").ToString())

        Footer_Net = ""
        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "EM" Then

            Footer_Net = "<Footer>" & vbCrLf
            Footer_Net = Footer_Net & "<Measurements item='NetWeightKilograms'>" & vbCrLf
            Footer_Net = Footer_Net & "<MeasurementValue>" & Replace(CStr(PesoLiquidoF), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer_Net = Footer_Net & "</Measurements>" & vbCrLf
            Footer_Net = Footer_Net & "</Footer>"


            Footer_Net = Footer_Net & "<Footer>" & vbCrLf
            Footer_Net = Footer_Net & "<Measurements item='VolumeCubicMeters'>" & vbCrLf
            Footer_Net = Footer_Net & "<MeasurementValue>" & Replace(CStr(qtd_tot_vol), ",", ".") & "</MeasurementValue>" & vbCrLf
            Footer_Net = Footer_Net & "</Measurements>" & vbCrLf
            Footer_Net = Footer_Net & "</Footer>"


        End If

    End Function


    Private Function Incoterm(ByRef strCodigo As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select nome_Tp_oper from tipo_oper with(nolock) where cd_tp_oper='" & strCodigo & "' "
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Incoterm = ""
        If ltempDT.Rows.Count > 0 Then
            Incoterm = ltempDT.Rows(0)("nome_tp_oper").ToString()
        End If
    End Function


    Private Function Data_BL() As String

        Data_BL = ""

        If IsDBNull(ProcessoDT.Rows(0)("dt_bl")) = True Then
            Exit Function
        End If
        Data_BL = "<Status>" & vbCrLf
        Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
            Case "EM"
                Data_BL = Data_BL & "<StatusType type='BLDate'/>" & vbCrLf
            Case "EA"
                Data_BL = Data_BL & "<StatusType type='AWBDate'/>" & vbCrLf
            Case "IA"
                Data_BL = Data_BL & "<StatusType type='AWBDate'/>" & vbCrLf
            Case "IM"
                Data_BL = Data_BL & "<StatusType type='BLDate'/>" & vbCrLf
            Case "IO"
                Data_BL = Data_BL & "<StatusType type='BLDate'/>" & vbCrLf
            Case "EO"
                Data_BL = Data_BL & "<StatusType type='BLDate'/>" & vbCrLf

        End Select
        Data_BL = Data_BL & "<StatusDate>" & VB6.Format(ProcessoDT.Rows(0)("dt_bl").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
        Data_BL = Data_BL & "</Status>"

    End Function



    Private Function Produtos_Brand() As String
        Dim Produtos As Object

        Dim ltempDT As New Data.DataTable

        StrSql = "select nome_tp_prod from tipo_produto with(nolock) where cd_tp_prod='" & ProcessoDT.Rows(0)("cd_tp_prod").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Produtos_Brand = ltempDT.Rows(0)("nome_tp_prod").ToString()
        Else
            Produtos_Brand = "Carga Geral"
        End If

        If Produtos_Brand = "" Then Produtos = "Carga Geral"

        Produtos_Brand = Upper_Case(Produtos_Brand)

    End Function


    'Private Sub Timer1_Tick(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Timer1.Tick

    '    If IntI > 150 Then
    '        Command1_Click(Command1, New System.EventArgs())
    '        lblStatus.Text = CStr(Now)
    '        IntI = 0
    '    Else
    '        IntI = IntI + 1
    '    End If

    'End Sub

    Private Function Verifica_Arquivo(ByRef strProcesso As String) As Boolean

        Dim ltempDT As New Data.DataTable
        Dim StrRetorno As String



        Verifica_Arquivo = True
        StrSql = "select * from grupo with(nolock) where grupo='" & Mid(strProcesso, 3, 3) & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then
            Exit Function
        End If

        ltempDT = New DataTable()


        If VB.Left(strProcesso, 2) = "IM" Then
            StrSql = "select cd_org_him from house_imp_mar with(nolock) where num_proc_him='" & strProcesso & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count = 0 Then
                Verifica_Arquivo = False
                Exit Function
            End If

            If IsDBNull(ltempDT.Rows(0)("cd_org_him")) = True Then
                Verifica_Arquivo = False
                Exit Function
            End If

            ltempDT = New DataTable()
        End If


        Verifica_Arquivo = True
        StrErro = ""
        Exit Function
        'Verifica ETA e ETD
        '************************************************************************************************************************

        Select Case UCase(VB.Left(strProcesso, 2))
            Case "EM"
                StrSql = "select ata_lem ATA,eta_lem ETA,etd_lem ETD,ATD_Lem Saida from llp_exp_mar with(nolock) where num_proc_lem='" & VB.Left(strProcesso, 16) & "'"
            Case "EA"
                StrSql = "select ata_lea ATA,eta_lea ETA,etd_lea ETD,ATD_Lea Saida from llp_exp_aer with(nolock) where num_proc_lea='" & VB.Left(strProcesso, 16) & "'"
            Case "IA"
                StrSql = "select ata_lia ATA,eta_lia ETA,etd_lia ETD,ATD_Lia Saida from llp_imp_aer with(nolock) where num_proc_lia='" & VB.Left(strProcesso, 16) & "'"
            Case "IM"
                StrSql = "select ata_lim ATA,eta_lim ETA,etd_lim ETD,ATD_Lim Saida from llp_imp_mar with(nolock) where num_proc_lim='" & VB.Left(strProcesso, 16) & "'"
            Case "IO"
                StrSql = "select ata_lio ATA,eta_lio ETA,etd_lio ETD,ATD_Lio Saida from llp_imp_out with(nolock) where num_proc_lio='" & VB.Left(strProcesso, 16) & "'"
            Case "EO"
                StrSql = "select ata_leo ATA,eta_leo ETA,etd_leo ETD,ATD_Leo Saida from llp_exp_out with(nolock) where num_proc_leo='" & VB.Left(strProcesso, 16) & "'"

        End Select


        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then
            StrErro = "01 - Processo n�o encontrado"
            Verifica_Arquivo = False
            Exit Function
        Else

            If IsDBNull(ltempDT.Rows(0)("ETA")) = True Or IsDBNull(ltempDT.Rows(0)("ETD")) = True Then
                StrErro = "02 - ETA ou ETD inv�lido"
                Verifica_Arquivo = False
                Exit Function
            End If
            If CDate(ltempDT.Rows(0)("ETA").ToString()) < CDate(ltempDT.Rows(0)("ETD").ToString()) Then
                StrErro = "02 - ETA ou ETD inv�lido"
                Verifica_Arquivo = False
                Exit Function
            End If
        End If



        'Verifica Armador
        '****************************************************************************************************************************
        If SCAC(strProcesso) = "" Then
            StrErro = "03 - SCAC Code n�o encontrado"
            Verifica_Arquivo = False
            Exit Function
        End If

        'Verifica Pais
        '****************************************************************************************************************************

        ltempDT = New DataTable()
        Select Case UCase(VB.Left(strProcesso, 2))
            Case "EA"
                StrSql = "select cd_org_hea cd_org, cd_dst_hea Cd_Dst from house_exp_aer where num_proc_hea='" & strProcesso & "'"
            Case "EM"
                StrSql = "select cd_org_hem cd_org, cd_dst_hem Cd_Dst from house_exp_mar where num_proc_hem='" & strProcesso & "'"
            Case "IM"
                StrSql = "select cd_org_him cd_org, cd_dst_him Cd_Dst from house_imp_mar where num_proc_him='" & strProcesso & "'"
            Case "IA"
                StrSql = "select cd_org_hia cd_org, cd_dst_hia Cd_Dst from house_imp_aer where num_proc_hia='" & strProcesso & "'"
            Case "IO"
                StrSql = "select cd_org_hio cd_org, cd_dst_hio Cd_Dst from house_imp_out where num_proc_hio='" & strProcesso & "'"
            Case "EO"
                StrSql = "select cd_org_heo cd_org, cd_dst_heo Cd_Dst from house_exp_out where num_proc_heo='" & strProcesso & "'"
        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If Pais(ltempDT.Rows(0)("cd_org").ToString()) = "" Or Pais(ltempDT.Rows(0)("cd_dst").ToString()) = "" Then
            StrErro = "04 - Pais de Origem ou Pais de Destino Inv�lido"
            Verifica_Arquivo = False
            Exit Function
        End If

        ltempDT = New DataTable()
        'Verifica PO
        '****************************************************************************************************************************


        If SellerRef(strProcesso, strProcesso, "V", "SalesOrder") = "" Then
            StrErro = "05 - Referencia do Cliente n�o informada"
            Verifica_Arquivo = False
            Exit Function
        End If


        'Verifica Produtos
        '****************************************************************************************************************************

        '    Select Case Left(StrProcesso, 2)
        '        Case "EM"
        '           StrSql = "Select * from prd_hou_exp_mar where num_proc_hem='" & StrProcesso & "'"
        '        Case "EA"
        '               StrSql = "Select * from prd_hou_exp_aer where num_proc_hea='" & StrProcesso & "'"
        '    End Select
        '
        '    RsTemp.Open StrSql, Conexao, adOpenForwardOnly, adLockReadOnly
        '
        '     If ltempDT.Rows.Count = 0 Thenn
        '        StrErro = "06 - Descric�o n�o informada"
        '        Verifica_Arquivo = False
        '        Exit Function
        '    End If
        '
        '    RsTemp.Close


        'Incoterm
        '****************************************************************************************************************************
        Select Case UCase(VB.Left(strProcesso, 2))
            Case "EM"
                StrSql = "select cd_tp_oper from house_exp_mar with(nolock) where num_proc_hem='" & strProcesso & "'"
            Case "EA"
                StrSql = "select cd_tp_oper from house_exp_aER with(nolock) where num_proc_heA='" & strProcesso & "'"
            Case "IA"
                StrSql = "select cd_tp_oper from house_imp_AER with(nolock) where num_proc_hiA='" & strProcesso & "'"
            Case "IM"
                StrSql = "select cd_tp_oper from house_imp_mar with(nolock) where num_proc_hiM='" & strProcesso & "'"
            Case "IO"
                StrSql = "select cd_tp_oper from house_imp_out with(nolock) where num_proc_hio='" & strProcesso & "'"
            Case "EO"
                StrSql = "select cd_tp_oper from house_exp_out with(nolock) where num_proc_heo='" & strProcesso & "'"



        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then
            StrSql = "07 - Incoterm n�o informado"
            Verifica_Arquivo = False
            Exit Function
        End If

        ltempDT = New DataTable()
        If Verifica_Arquivo = False Then
            StrRetorno = Retorna_Erro(strProcesso, StrErro)
        End If


    End Function


    Private Function Retorna_Erro(ByRef strProcesso As String, ByRef StrRetorno As String) As String

        Dim StrEmail As String

        Select Case UCase(VB.Left(StrRetorno, 2))
            Case "01"
                StrEmail = "sistemas@bdp.com.br"
            Case "02"
                StrEmail = IIf(VB.Left(strProcesso, 2) = "EM", "oceanoperations@bdp.com.br", "airoperations@bdp.com.br")
            Case "03"
                StrEmail = "sistemas@bdp.com.br"
            Case "04"
                StrEmail = "sistemas@bdp.com.br"
            Case "05"
                StrEmail = "csr@bdp.com.br"
            Case "06"
                StrEmail = "csr@bdp.com.br"
        End Select

        StrSql = "insert into cml.dbo.exchange_erros values('" & strProcesso & "','" & StrEmail & "','" & StrRetorno & "',getdate(),null)"
        sqlCnn.ExecutaComando(StrSql)

        Retorna_Erro = ""

    End Function

    Private Sub Lista_Processos_ER()

        Dim ltempDT As New Data.DataTable
        Dim IntI As Decimal
        Dim StrServidor As String
        Dim StrSenha As String
        Dim StrUsuario As String

        Exit Sub

        StrServidor = "200.200.130.226"
        StrSenha = "cdssquidrestart"
        StrUsuario = "SA"




        StrUltimo = "BDPBRSAO_" & VB6.Format(Now, "yyyymmddhhmmss") & ".xml"
        StrSql = "select num_proc from cml.dbo.exchange_erros " & " Where data_solucao Is Null " & " group by Num_proc"

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        StrSql = "exec cml.dbo.pExchange_Ins"
        sqlCnn.ExecutaComando(StrSql)


        flx.set_ColWidth(0, 4000)
        flx.set_ColWidth(1, 2000)

        IntI = 1
        For Each lTempDR As DataRow In ltempDT.Rows

            If Verifica_Arquivo(lTempDR.Item("num_proc")) = True Then

                Gera_Arquivos((lTempDR.Item("num_proc").ToString()))
                StrSql = "update cml.dbo.exchange_erros set data_solucao=getdate() where num_proc='" & ltempDT.Rows(0)("num_proc").ToString() & "'"
                sqlCnn.ExecutaComando(StrSql)

            End If
            While IntI <= 999999
                IntI = IntI + 1
            End While
            IntI = 0
        Next




        lblStatus.Text = CStr(Now)

    End Sub
    Private Function Nature_Goods_Samples() As String

        'Utilizado para os casos Samples da Dow
        'Quando � Samples, o sistema deve enviar a Descricao informada no ATL n�o o cadastro do Produto
        Dim ltempDT As New Data.DataTable
        Dim total As Integer
        Dim IntI As Integer
        Dim strALLDescription As String

        IntI = 0
        Nature_Goods_Samples = ""
        strALLDescription = ""
        StrSql = "select [dbo].[RemoveNonAlphaCharacters](descr) descr ,len(descr) length from nature_Goods where num_proc='" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            Nature_Goods_Samples = ltempDT.Rows(0)("descr").ToString()
            strALLDescription = Replace(ltempDT.Rows(0)("descr").ToString(), vbCrLf, " ")
            If strALLDescription = Nothing Then
                total = 0
            Else
                total = strALLDescription.Length
            End If
            If total > 250 Then
                Nature_Goods_Samples = ""
                While total > IntI
                    If strALLDescription.Length > 250 Then
                        Nature_Goods_Samples = Nature_Goods_Samples + strALLDescription.Substring(0, 250) + vbCrLf
                        strALLDescription = strALLDescription.Remove(0, 250)
                    Else
                        Nature_Goods_Samples = Nature_Goods_Samples + strALLDescription.Substring(0, strALLDescription.Length) + vbCrLf
                    End If
                    IntI = IntI + 250
                End While
            End If
        End If

    End Function

    Private Function Marks() As String

        Marks = "<Marks>" & "<![CDATA[" & vbCrLf
        Marks = Marks & IIf(Upper_Case(Nature_Goods_Samples) = "", "N/I", Replace(Upper_Case(Nature_Goods_Samples), vbCrLf, "]]>" & "</Marks><Marks>" & "<![CDATA[")) & vbCrLf
        Marks = Marks & "]]>" & "</Marks>"

    End Function
    Private Function Produto_Novo_ProdutoCodesName() As String

        Dim ltempDT As New Data.DataTable
        Dim StrSaida As String

        StrSaida = ""

        StrSql = "spIntSmartNCM_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        Produto_Novo_ProdutoCodesName = ""
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then Exit Function
        StrSaida = "<ProductCodesNames>"
        StrSaida = StrSaida & "<ProductCodesNamesType>" & "TariffClassification" & "</ProductCodesNamesType>"
        StrSaida = StrSaida & "<ProductCodesNamesName>" & Upper_Case(ltempDT.Rows(0)("descricao_ncm").ToString()) & "</ProductCodesNamesName>"
        StrSaida = StrSaida & "<ProductCodesNamesCode>" & VB.Left(ltempDT.Rows(0)("ncm").ToString(), 8) & "</ProductCodesNamesCode>"
        StrSaida = StrSaida & "</ProductCodesNames>"

        Produto_Novo_ProdutoCodesName = StrSaida

    End Function
    Private Function Produto_Novo_ProdutoCodesName_DestinationInland() As String

        Dim ltempDT As New Data.DataTable

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) <> "I" Then Exit Function

        StrSql = "spINTSmartTransportadora_SEl '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Produto_Novo_ProdutoCodesName_DestinationInland = ""
        If ltempDT.Rows.Count > 0 Then

            Produto_Novo_ProdutoCodesName_DestinationInland = "<ProductCodesNames>"
            Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNamesType>" & "DestinationInlandCarrier" & "</ProductCodesNamesType>"
            Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNamesName>" & Upper_Case(ltempDT.Rows(0)("Transportadora").ToString()) & "</ProductCodesNamesName>"
            Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNamesCode>" & "</ProductCodesNamesCode>"
            Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "</ProductCodesNames>"


            If IsDBNull(ltempDT.Rows(0)("SCAC").ToString()) = False Then
                Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNames>"
                Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNamesType>" & "DestinationInlandCarrier" & "</ProductCodesNamesType>"
                Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNamesName>" & Upper_Case(ltempDT.Rows(0)("SCAC").ToString()) & "</ProductCodesNamesName>"
                Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "<ProductCodesNamesCode>" & "</ProductCodesNamesCode>"
                Produto_Novo_ProdutoCodesName_DestinationInland = Produto_Novo_ProdutoCodesName_DestinationInland & "</ProductCodesNames>"


            End If


        End If



    End Function


    Private Function Produto_Novo_ProdutoCodesName_HAZ() As String

        Dim ltempDT As New Data.DataTable

        If UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1)) <> "E" Then Exit Function

        StrSql = "spINTSmartProdutoCodesName_HAZ_SEL '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Produto_Novo_ProdutoCodesName_HAZ = ""
        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("HAZTunnelClassCode").ToString()) = False And ltempDT.Rows(0)("HAZTunnelClassCode").ToString().Length > 0 Then
                Produto_Novo_ProdutoCodesName_HAZ = "<ProductCodesNames>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNamesType>" & "HAZTunnelClassCode" & "</ProductCodesNamesType>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNamesName>" & Upper_Case(ltempDT.Rows(0)("HAZTunnelClassCode").ToString()) & "</ProductCodesNamesName>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNamesCode>" & "</ProductCodesNamesCode>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "</ProductCodesNames>"
            End If

            If IsDBNull(ltempDT.Rows(0)("HazADNRCode").ToString()) = False And ltempDT.Rows(0)("HazADNRCode").ToString().Length > 0 Then
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNames>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNamesType>" & "HazADNRCode" & "</ProductCodesNamesType>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNamesName>" & Upper_Case(ltempDT.Rows(0)("HazADNRCode").ToString()) & "</ProductCodesNamesName>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "<ProductCodesNamesCode>" & "</ProductCodesNamesCode>"
                Produto_Novo_ProdutoCodesName_HAZ = Produto_Novo_ProdutoCodesName_HAZ() & "</ProductCodesNames>"


            End If


        End If



    End Function
    Private Function Produto_Novo_ProdutoCodesName_OGA() As String

        Dim ltempDT As New Data.DataTable
        Dim StrSaida As String
        Dim StrOGAReleaseDAte As String
        Dim StrOGASubmitDate As String

        StrSaida = ""

        StrSql = "spIntSmartOGA_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        Produto_Novo_ProdutoCodesName_OGA = ""
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then Exit Function


        If (IsDBNull(ltempDT.Rows(0)("Data_Release_OGA")) = True) Then
            StrOGAReleaseDAte = ""
        Else
            StrOGAReleaseDAte = VB6.Format(ltempDT.Rows(0)("Data_Release_OGA").ToString(), "yyyymmdd")
        End If


        If IsDBNull(ltempDT.Rows(0)("Data_Submit_OGA")) = True Then
            StrOGASubmitDate = ""
        Else
            StrOGASubmitDate = VB6.Format(ltempDT.Rows(0)("Data_Submit_OGA").ToString(), "yyyymmdd")
        End If




        Produto_Novo_ProdutoCodesName_OGA = ""
        For Each lTempDR As DataRow In ltempDT.Rows


            StrSaida = "<ProductCodesNames>"
            StrSaida = StrSaida & "<ProductCodesNamesType>" & "OGA" & "</ProductCodesNamesType>"
            StrSaida = StrSaida & "<ProductCodesNamesName>" & Upper_Case(lTempDR.Item("Nome_OGA").ToString()) & "</ProductCodesNamesName>"
            StrSaida = StrSaida & "<ProductCodesNamesCode>" & Upper_Case(lTempDR.Item("Nome_OGA").ToString()) & "</ProductCodesNamesCode>"
            StrSaida = StrSaida & "</ProductCodesNames>"

            Produto_Novo_ProdutoCodesName_OGA = Produto_Novo_ProdutoCodesName_OGA & StrSaida

        Next

        StrSaida = ""

        If StrOGAReleaseDAte <> "" Then
            StrSaida = "<ProductDates>"
            StrSaida = StrSaida & "<ProductDatesType>OGAReleaseDate</ProductDatesType>"
            StrSaida = StrSaida & "<ProductDatesDate>" & StrOGAReleaseDAte & "</ProductDatesDate>"
            StrSaida = StrSaida & "</ProductDates>"
        End If

        If StrOGASubmitDate <> "" Then
            StrSaida = "<ProductDates>"
            StrSaida = StrSaida & "<ProductDatesType>OGASubmissionDate</ProductDatesType>"
            StrSaida = StrSaida & "<ProductDatesDate>" & StrOGASubmitDate & "</ProductDatesDate>"
            StrSaida = StrSaida & "</ProductDates>"
        End If

        Produto_Novo_ProdutoCodesName_OGA = Produto_Novo_ProdutoCodesName_OGA & StrSaida


        '    <ProductCodesNames>
        '          <ProductCodesNamesType>OGA</ProductCodesNamesType>
        '          <ProductCodesNamesName>ProductCodesNamesName>
        '          <ProductCodesNamesCode></ProductCodesNamesCode>
        '</ProductCodesNames>
        '- Other Government Agencies Reject Date
        '<ProductDates>
        '         <ProductDatesType>OGARejectDate</ProductDatesType>
        '         <ProductDatesDate></ProductDatesDate>
        '</ProductDates>
        '- Other Government Agencies Release Date
        '<ProductDates>
        '         <ProductDatesType>OGAReleaseDate</ProductDatesType>
        '         <ProductDatesDate></ProductDatesDate>
        '</ProductDates>
        '
        '- Other Government Agencies Submit Date
        '
        '<ProductDates>
        '         <ProductDatesType>OGASubmissionDate</ProductDatesType>
        '         <ProductDatesDate></ProductDatesDate>
        ''

    End Function

    Private Function ProductStatement() As String

        Dim strLine As String

        ProductStatement = ""
        ProductStatement = ProductStatement & "<ProductStatements>"

        ProductStatement = ProductStatement & "<ProductStatement> <![CDATA[" & IIf(IsDBNull(ProcessoDT.Rows(0)("obs")) = True, "", ProcessoDT.Rows(0)("obs").ToString()) & "]]></ProductStatement>"
        ProductStatement = ProductStatement & "</ProductStatements>"

    End Function
    Private Function BLDescr(ByRef strProcesso As String, ByRef strPRoduto As String) As String

        Dim ltempDT As New Data.DataTable
        Dim strLine As Object
        Dim strRE As String
        StrSql = "spSmartProdutoContainer_INT '" & strProcesso & "','" & strPRoduto & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)


        For Each lTempDR As DataRow In ltempDT.Rows
            strLine = strLine + "   " + lTempDR.Item("num_cont_em").ToString() + "Seal: " + CStr(ltempDT.Rows(0)("num_lacre_em").ToString()) + "  "
            strLine = strLine + "  " + lTempDR.Item("produto_Descr").ToString()
            strRE = ltempDT.Rows(0)("re").ToString()
        Next

        BLDescr = Upper_Case(BLDescr)
        BLDescr = "<BLDesc>" + strLine + "RE:" + strRE + "</BLDesc>"



    End Function

    Private Function Produto_Novo_VolAer(ByRef strProcesso As String) As String

        Dim StrSaida As String
        Dim ltempDT As New Data.DataTable

        StrSql = "spVolumeSmart_Sel '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Produto_Novo_VolAer = ""
            Produto_Novo_VolAer = Produto_Novo_VolAer & "<NoOfPkgs>" & Replace(CStr(ltempDT.Rows(0)("Vol").ToString()), ",", "") & "</NoOfPkgs>"

            Produto_Novo_VolAer = Produto_Novo_VolAer & "<TypePkgCode>" & IIf(IsDBNull(ltempDT.Rows(0)("cd_smart")) = True, "", ltempDT.Rows(0)("cd_smart").ToString()) & "</TypePkgCode>" & vbCrLf

            Produto_Novo_VolAer = Produto_Novo_VolAer & "<TypePkgDesc>" & IIf(IsDBNull(ltempDT.Rows(0)("Nome_Tp_Embal")) = True, "", ltempDT.Rows(0)("Nome_Tp_Embal").ToString()) & "</TypePkgDesc>" & vbCrLf
        End If

    End Function
    'Private Function Produto_Novo() As String
    '    Dim peso_liquido As Object

    '     Dim ltempDT As New Data.DataTable
    '    Dim IntI As Short
    '    Dim PesoBrutoProduto As Decimal
    '    Dim PesoLiquidoProduto As Decimal

    '    If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 5) = "EMMSF" Then
    '        Produto_Novo = ""
    '        Exit Function
    '    End If
    '    PesoLiquido = 0
    '    PesoBruto = 0
    '    StrSql = "spINT_Invoice '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
    '    IntI = 1
    '    ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '    Produto_Novo = ""
    '     If ltempDT.Rows.Count > 0 Then
    '        While RsTemp.EOF = False
    '            Produto_Novo = Produto_Novo & "<Detail>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ProductDetail action='Add'>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<LineItemNo>" & CStr(IntI) & "</LineItemNo>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ProductCode>" + lTempDT.Rows(0)("Gmid").toString() + "</ProductCode>" + vbCrLf
    '            Produto_Novo = Produto_Novo & "<BrandName><![CDATA[" & Upper_Case(lTempDT.Rows(0)("brandname").toString()) & "]]></BrandName>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<InvoiceDesc><![CDATA[" & Upper_Case(lTempDT.Rows(0)("brandname").toString()) & "]]></InvoiceDesc>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<BLDesc>" & IIf(Upper_Case(Nature_Goods_Samples.ToString()) = "", "N/I", Replace(Upper_Case(Nature_Goods_Samples.ToString()), vbCrLf, "</BLDesc><BLDesc>")) & "</BLDesc>" & vbCrLf

    '            '            Produto_Novo = Produto_Novo + BLDescr(strProcesso, rsTemp!gmid)
    '            'INICIO HTS
    '            Produto_Novo = Produto_Novo & "<Compliance>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ClassificationNumber>" & (Busca_NCM(ProcessoDT.Rows(0)("processo").ToString())) & "</ClassificationNumber> " & vbCrLf
    '            Produto_Novo = Produto_Novo & " <Domestic-Foreign>D</Domestic-Foreign>"
    '            Produto_Novo = Produto_Novo & " <DrawbackInd>N</DrawbackInd>"
    '            Produto_Novo = Produto_Novo & "</Compliance>"
    '            'FIM HTS
    '            If lTempDT.Rows(0)("tipo_unid").toString() = "KG" And lTempDT.Rows(0)("quantidade").toString() < peso_liquido Then
    '                Produto_Novo = Produto_Novo & "<BilledQuantity>" & Replace(lTempDT.Rows(0)("peso_liquido").ToString(), ",", ".") & "</BilledQuantity>" & vbCrLf
    '            Else
    '                Produto_Novo = Produto_Novo & "<BilledQuantity>" & Replace(lTempDT.Rows(0)("quantidade").ToString(), ",", ".") & "</BilledQuantity>" & vbCrLf
    '            End If

    '            Produto_Novo = Produto_Novo & "<BilledQuantityUnit>" & IIf(IsDBNull(lTempDT.Rows(0)("tipo_unid")) = True, "", lTempDT.Rows(0)("tipo_unid").toString()) & "</BilledQuantityUnit>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<Price>" & Replace(lTempDT.Rows(0)("preco_unit").ToString(), ",", ".") & "</Price>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ProductAmount>" & Replace(CStr(Replace(CStr(lTempDT.Rows(0)("preco_unit").toString() * lTempDT.Rows(0)("quantidade").toString()), ".", ",")), ",", ".") & "</ProductAmount>"
    '            Produto_Novo = Produto_Novo & "<CurrencyCode>" & "USD" & "</CurrencyCode>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<CountryofOriginCode>" & Pais(ProcessoDT.Rows(0)("cd_org").toString()) & "</CountryofOriginCode>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<CountryofOriginName>" & Nome_Pais(ProcessoDT.Rows(0)("cd_org").toString()) & "</CountryofOriginName>" & vbCrLf

    '            If ProcessoDT.Rows(0)("tipo_carga").toString() <> "BULK" Then
    '                Produto_Novo = Produto_Novo & "<NoOfPkgs>" & Replace(CStr(lTempDT.Rows(0)("quantidade").toString() / IIf(lTempDT.Rows(0)("capac").toString() = 0, 1, lTempDT.Rows(0)("capac").toString())), ",", ".") & "</NoOfPkgs>"

    '                Produto_Novo = Produto_Novo & "<TypePkgCode>" & IIf(IsDBNull(lTempDT.Rows(0)("cd_embalagem")) = True, "", lTempDT.Rows(0)("cd_embalagem").toString()) & "</TypePkgCode>" & vbCrLf

    '                Produto_Novo = Produto_Novo & "<TypePkgDesc>" & IIf(IsDBNull(lTempDT.Rows(0)("Nome_Tp_Embal")) = True, "", lTempDT.Rows(0)("Nome_Tp_Embal").toString()) & "</TypePkgDesc>" & vbCrLf
    '                Produto_Novo = Produto_Novo & "<NoOfPlts>" & Replace(CStr(lTempDT.Rows(0)("quantidade").toString() / IIf(lTempDT.Rows(0)("capac").toString() = 0, 1, lTempDT.Rows(0)("capac").toString())), ",", ".") & "</NoOfPlts>"
    '            Else
    '                Produto_Novo = Produto_Novo & "<NoOfPkgs>" & "</NoOfPkgs>"
    '                Produto_Novo = Produto_Novo & "<TypePkgCode>" & "</TypePkgCode>" & vbCrLf
    '                Produto_Novo = Produto_Novo & "<TypePkgDesc>" & "</TypePkgDesc>" & vbCrLf
    '                Produto_Novo = Produto_Novo & "<NoOfPlts>" & "</NoOfPlts>"
    '            End If

    '            'PESO BRUTO
    '            '            Produto_Novo = Produto_Novo + Produto_Novo_ProdutoCodesName

    '            Produto_Novo = Produto_Novo & "<Measurements type='GrsWtKgs'>" & vbCrLf

    '            Produto_Novo = Produto_Novo & "<MeasurementValue>" & CStr(Replace(IIf(IsDBNull(lTempDT.Rows(0)("Peso_Bruto")) = True, 0, lTempDT.Rows(0)("Peso_Bruto").toString()), ",", ".")) & "</MeasurementValue>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf
    '            'PESO LIQUIDO
    '            Produto_Novo = Produto_Novo & "<Measurements type='NetWtKgs'>" & vbCrLf

    '            Produto_Novo = Produto_Novo & "<MeasurementValue>" & CStr(Replace(IIf(IsDBNull(lTempDT.Rows(0)("peso_liquido")) = True, 0, lTempDT.Rows(0)("peso_liquido").toString()), ",", ".")) & "</MeasurementValue>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf
    '            'ACUMULADOR PESOS

    '            PesoLiquido = PesoLiquido + IIf(IsDBNull(lTempDT.Rows(0)("peso_liquido")) = True, 0, lTempDT.Rows(0)("peso_liquido").toString())

    '            PesoBruto = PesoBruto + IIf(IsDBNull(lTempDT.Rows(0)("Peso_Bruto")) = True, 0, lTempDT.Rows(0)("Peso_Bruto").toString())
    '            Produto_Novo = Produto_Novo & "<PrimaryRptQty>" & Replace(lTempDT.Rows(0)("quantidade").ToString(), ",", ".") & "</PrimaryRptQty>"

    '            Produto_Novo = Produto_Novo & "<PrimaryRptQtyUOM>" & IIf(IsDBNull(lTempDT.Rows(0)("tipo_unid")) = True, "", lTempDT.Rows(0)("tipo_unid").toString()) & "</PrimaryRptQtyUOM>"
    '            Produto_Novo = Produto_Novo & "<SecondaryRptQty>" & Replace(lTempDT.Rows(0)("quantidade").ToString(), ",", ".") & "</SecondaryRptQty>"

    '            Produto_Novo = Produto_Novo & "<SecondaryRptQtyUOM>" & IIf(IsDBNull(lTempDT.Rows(0)("tipo_unid")) = True, "", lTempDT.Rows(0)("tipo_unid").toString()) & "</SecondaryRptQtyUOM>"
    '            Produto_Novo = Produto_Novo & "<EnterValue>" & Replace(CStr(Replace(CStr(lTempDT.Rows(0)("preco_unit").toString() * lTempDT.Rows(0)("quantidade").toString()), ".", ",")), ",", ".") & "</EnterValue>"
    '            Produto_Novo = Produto_Novo & "</ProductDetail>"
    '            Produto_Novo = Produto_Novo & LicenseProduto(strProcesso)
    '            Produto_Novo = Produto_Novo & SBU(lTempDT.Rows(0)("Gmid").toString())
    '            Produto_Novo = Produto_Novo & ProductStatement()
    '            Produto_Novo = Produto_Novo & HazardousDetail(lTempDT.Rows(0)("Gmid").toString())
    '            Produto_Novo = Produto_Novo & ContainerProduto(strProcesso, lTempDT.Rows(0)("Gmid").toString())

    '            Produto_Novo = Produto_Novo & ProductsAmounts()
    '            'Total na RE
    '            Produto_Novo = Produto_Novo & "<ProductAmounts>"
    '            Produto_Novo = Produto_Novo & "<ProductAmountType>" & "ReportableValueAmount" & "</ProductAmountType>"
    '            Produto_Novo = Produto_Novo & "<ProductAmountValue>" & Replace(CStr(Replace(CStr(lTempDT.Rows(0)("preco_unit").toString() * lTempDT.Rows(0)("quantidade").toString()), ".", ",")), ",", ".") & "</ProductAmountValue>"
    '            Produto_Novo = Produto_Novo & "<ProductAmountCurrency>" & "USD" & "</ProductAmountCurrency>"
    '            Produto_Novo = Produto_Novo & "</ProductAmounts>"

    '            Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_DestinationInland()
    '            Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName()
    '            Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_OGA()

    '            If SBU(lTempDT.Rows(0)("Gmid").toString()) <> "" Then Produto_Novo = Produto_Novo
    '            'Produto_Novo = Produto_Novo + Duty
    '            IntI = IntI + 1
    '            Produto_Novo = Produto_Novo & ProductFees(lTempDT.Rows(0)("Gmid").toString())
    '            RsTemp.MoveNext()
    '            '           Produto_Novo = Produto_Novo + Produto_Novo_ProdutoCodesName
    '            Produto_Novo = Produto_Novo & "</Detail>"
    '        End While
    '        RsTemp.Close()
    '        '        StrSql = "spINT_Invoice '" & RsProcesso!Processo & "'"
    '        '        RsTemp.Open StrSql, Conexao, adOpenForwardOnly, adLockReadOnly
    '        '        While RsTemp.EOF = False
    '        '            If SBU(RsTemp!gmid) <> "" Then Produto_Novo = Produto_Novo + SBU(RsTemp!gmid)
    '        '            RsTemp.MoveNext
    '        '        Wend
    '    Else
    '        RsTemp.Close()
    '        StrSql = "spINT_PEDIDO '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
    '        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
    '        While RsTemp.EOF = False
    '            Produto_Novo = Produto_Novo & "<Detail>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ProductDetail action='Add'>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<LineItemNo>" & CStr(IntI) & "</LineItemNo>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ProductCode>" + lTempDT.Rows(0)("Gmid").toString() + "</ProductCode>" + vbCrLf
    '            Produto_Novo = Produto_Novo & "<BrandName><![CDATA[" & IIf(VB.Left(lTempDT.Rows(0)("Gmid").toString(), 1) = "9", Upper_Case(Nature_Goods_Samples), Upper_Case(lTempDT.Rows(0)("brandname").toString())) & "]]></BrandName>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<InvoiceDesc><![CDATA[" & IIf(VB.Left(lTempDT.Rows(0)("Gmid").toString(), 1) = "9", Upper_Case(Replace(Nature_Goods_Samples, vbCrLf, " ")), Upper_Case(lTempDT.Rows(0)("brandname").toString())) & "]]></InvoiceDesc>" + vbCrLf
    '            Produto_Novo = Produto_Novo & "<BLDesc><![CDATA[" & Replace(Upper_Case(Nature_Goods_Samples), vbCrLf, "]]></BLDesc><BLDesc><![CDATA[") & "]]></BLDesc>" & vbCrLf

    '            '            Produto_Novo = Produto_Novo + BLDescr(strProcesso, rsTemp!gmid)

    '            'INCIO HTS
    '            Produto_Novo = Produto_Novo & "<Compliance>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ClassificationNumber>" & Busca_NCM(ProcessoDT.Rows(0)("processo").ToString()) & "</ClassificationNumber> " & vbCrLf
    '            Produto_Novo = Produto_Novo & " <Domestic-Foreign>D</Domestic-Foreign>"
    '            Produto_Novo = Produto_Novo & " <DrawbackInd>N</DrawbackInd>"
    '            Produto_Novo = Produto_Novo & "</Compliance>"
    '            'FIM HTS
    '            Produto_Novo = Produto_Novo & "<BilledQuantity>" & Replace(lTempDT.Rows(0)("quantidade").ToString(), ",", ".") & "</BilledQuantity>" & vbCrLf

    '            Produto_Novo = Produto_Novo & "<BilledQuantityUnit>" + IIf(IsDBNull(lTempDT.Rows(0)("tipo_unid")) = True, "", lTempDT.Rows(0)("tipo_unid").toString()) & "</BilledQuantityUnit>" & vbCrLf

    '            Produto_Novo = Produto_Novo & "<Price>" & Replace(IIf(IsDBNull(lTempDT.Rows(0)("preco_unit")) = True, 0, lTempDT.Rows(0)("preco_unit").toString()), ",", ".") & "</Price>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<ProductAmount>" & Replace(CStr(lTempDT.Rows(0)("preco_unit").toString() * lTempDT.Rows(0)("quantidade").toString()), ",", ".") & "</ProductAmount>"
    '            Produto_Novo = Produto_Novo & "<CurrencyCode>" + lTempDT.Rows(0)("cd_Tp_moeda").toString() + "</CurrencyCode>" + vbCrLf
    '            Produto_Novo = Produto_Novo & "<CountryofOriginCode>" & Pais(ProcessoDT.Rows(0)("cd_org").toString()) & "</CountryofOriginCode>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<CountryofOriginName>" & Nome_Pais(ProcessoDT.Rows(0)("cd_org").toString()) & "</CountryofOriginName>" & vbCrLf
    '            If UCase(lTempDT.Rows(0)("tipo_unid").toString()) <> "KG" And UCase(lTempDT.Rows(0)("tipo_unid").toString()) <> "LB" Then
    '                Produto_Novo = Produto_Novo & "<NoOfPkgs>" & Replace(CStr(lTempDT.Rows(0)("quantidade").toString()), ",", "") & "</NoOfPkgs>"

    '                Produto_Novo = Produto_Novo & "<TypePkgCode>" & IIf(IsDBNull(lTempDT.Rows(0)("cd_dst")) = True, "", lTempDT.Rows(0)("cd_dst").toString()) & "</TypePkgCode>" & vbCrLf

    '                Produto_Novo = Produto_Novo & "<TypePkgDesc>" & IIf(IsDBNull(lTempDT.Rows(0)("descr_org")) = True, "", lTempDT.Rows(0)("descr_org").toString()) & "</TypePkgDesc>" & vbCrLf
    '            Else
    '                Produto_Novo = Produto_Novo & Produto_Novo_VolAer(strProcesso)
    '            End If

    '            'PESO BRUTO

    '            PesoBrutoProduto = IIf(IsDBNull(lTempDT.Rows(0)("peso_bruto_Tot")) = True, 0, lTempDT.Rows(0)("peso_bruto_Tot").toString())

    '            PesoLiquidoProduto = IIf(IsDBNull(lTempDT.Rows(0)("peso_liquido_Tot")) = True, 0, lTempDT.Rows(0)("peso_liquido_Tot").toString())

    '            If PesoBrutoProduto = 0 Then

    '                If IsDBNull(lTempDT.Rows(0)("Peso_Bruto")) = True Then
    '                    PesoBrutoProduto = 1 * lTempDT.Rows(0)("quantidade").toString()
    '                    PesoLiquidoProduto = 1 * lTempDT.Rows(0)("quantidade").toString()
    '                Else
    '                    PesoBrutoProduto = lTempDT.Rows(0)("Peso_Bruto").toString() * lTempDT.Rows(0)("quantidade").toString()
    '                    PesoLiquidoProduto = lTempDT.Rows(0)("Peso_Bruto").toString() * lTempDT.Rows(0)("quantidade").toString()
    '                End If
    '            End If
    '            '      Produto_Novo = Produto_Novo + Produto_Novo_ProdutoCodesName

    '            Produto_Novo = Produto_Novo & "<Measurements type='GrsWtKgs'>" & vbCrLf
    '            Select Case UCase(lTempDT.Rows(0)("peso_uom").toString())
    '                Case "LM"
    '                    PesoBrutoProduto = PesoBrutoProduto * (1000 / 2205)
    '                    PesoLiquidoProduto = PesoLiquidoProduto * (1000 / 2205)

    '                Case "LB"
    '                    PesoBrutoProduto = PesoBrutoProduto / 2205
    '                    PesoLiquidoProduto = PesoLiquidoProduto / 2205

    '            End Select
    '            'BDPSMART - Conversion failed when converting the varchar value '260.'

    '            Produto_Novo = Produto_Novo & "<MeasurementValue>" & Replace(CStr(PesoBrutoProduto), ",", ".") & "</MeasurementValue>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf
    '            'PESO LIQUIDO
    '            Produto_Novo = Produto_Novo & "<Measurements type='NetWtKgs'>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "<MeasurementValue>" & Replace(CStr(PesoLiquidoProduto), ",", ".") & "</MeasurementValue>" & vbCrLf
    '            Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf

    '            PesoLiquido = PesoLiquido + PesoLiquidoProduto
    '            PesoBruto = PesoBruto + PesoBrutoProduto
    '            Produto_Novo = Produto_Novo
    '            Produto_Novo = Produto_Novo & "<PrimaryRptQty>" & Replace(lTempDT.Rows(0)("quantidade").ToString(), ",", ".") & "</PrimaryRptQty>"

    '            Produto_Novo = Produto_Novo & "<PrimaryRptQtyUOM>" & IIf(IsDBNull(lTempDT.Rows(0)("tipo_unid")) = True, "", lTempDT.Rows(0)("tipo_unid").toString()) & "</PrimaryRptQtyUOM>"
    '            Produto_Novo = Produto_Novo & "<SecondaryRptQty>" & Replace(lTempDT.Rows(0)("quantidade").ToString(), ",", ".") & "</SecondaryRptQty>"

    '            Produto_Novo = Produto_Novo & "<SecondaryRptQtyUOM>" & IIf(IsDBNull(lTempDT.Rows(0)("tipo_unid")) = True, "", lTempDT.Rows(0)("tipo_unid").toString()) & "</SecondaryRptQtyUOM>"
    '            Produto_Novo = Produto_Novo & "<EnterValue>" & Replace(CStr(Replace(CStr(lTempDT.Rows(0)("preco_unit").toString() * lTempDT.Rows(0)("quantidade").toString()), ".", ",")), ",", ".") & "</EnterValue>"

    '            Produto_Novo = Produto_Novo & "</ProductDetail>"
    '            Produto_Novo = Produto_Novo & LicenseProduto(strProcesso)

    '            If SBU(lTempDT.Rows(0)("Gmid").toString()) <> "" Then Produto_Novo = Produto_Novo & SBU(lTempDT.Rows(0)("Gmid").toString())
    '            Produto_Novo = Produto_Novo & ProductStatement()
    '            Produto_Novo = Produto_Novo & HazardousDetail(lTempDT.Rows(0)("Gmid").toString())
    '            Produto_Novo = Produto_Novo & ContainerProduto(strProcesso, lTempDT.Rows(0)("Gmid").toString())
    '            Produto_Novo = Produto_Novo & ProductsAmounts()

    '            Produto_Novo = Produto_Novo & "<ProductAmounts>"
    '            Produto_Novo = Produto_Novo & "<ProductAmountType>" & "ReportableValueAmount" & "</ProductAmountType>"
    '            Produto_Novo = Produto_Novo & "<ProductAmountValue>" & Replace(CStr(Replace(CStr(lTempDT.Rows(0)("preco_unit").toString() * lTempDT.Rows(0)("quantidade").toString()), ".", ",")), ",", ".") & "</ProductAmountValue>"
    '            Produto_Novo = Produto_Novo & "<ProductAmountCurrency>" & "USD" & "</ProductAmountCurrency>"
    '            Produto_Novo = Produto_Novo & "</ProductAmounts>"



    '            Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_DestinationInland()
    '            Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName()
    '            Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_OGA()




    '            Produto_Novo = Produto_Novo & ProductDate(lTempDT.Rows(0)("Gmid").toString())
    '            '   Produto_Novo = Produto_Novo + Duty
    '            Produto_Novo = Produto_Novo & ProductFees(lTempDT.Rows(0)("Gmid").toString())

    '            IntI = IntI + 1
    '            RsTemp.MoveNext()
    '            Produto_Novo = Produto_Novo & "</Detail>"
    '        End While
    '        RsTemp.Close()
    '        '            StrSql = "spINT_PEDIDO '" & RsProcesso!Processo & "'"
    '        '            RsTemp.Open StrSql, Conexao, adOpenForwardOnly, adLockReadOnly
    '        '            While RsTemp.EOF = False
    '        '                If SBU(RsTemp!gmid) <> "" Then Produto_Novo = Produto_Novo + SBU(RsTemp!gmid)
    '        '                RsTemp.MoveNext
    '        '            Wend

    '    End If

    'End Function

    Private Function Produto_Novo_SB() As StringBuilder
        Dim peso_liquido As Object
        Dim Produto_Novo As String = Nothing
        Dim sb As New StringBuilder()
        Dim ltempDT As New Data.DataTable
        Dim IntI As Short
        Dim PesoBrutoProduto As Decimal
        Dim PesoLiquidoProduto As Decimal

        Produto_Novo_SB = Nothing

        If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 5) = "EMMSF" Then
            Produto_Novo = ""
            Produto_Novo_SB = Nothing
            Exit Function
        End If
        PesoLiquido = 0
        PesoBruto = 0
        StrSql = "spINT_Invoice '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        IntI = 1
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        Produto_Novo = ""
        If ltempDT.Rows.Count > 0 Then
            For Each lTempDR As DataRow In ltempDT.Rows

                Produto_Novo = Produto_Novo & "<Detail>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ProductDetail action='Add'>" & vbCrLf
                Produto_Novo = Produto_Novo & "<LineItemNo>" & CStr(IntI) & "</LineItemNo>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ProductCode>" + lTempDR.Item("Gmid").ToString() + "</ProductCode>" + vbCrLf
                Produto_Novo = Produto_Novo & "<BrandName><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></BrandName>" & vbCrLf
                Produto_Novo = Produto_Novo & "<InvoiceDesc><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></InvoiceDesc>" & vbCrLf
                Produto_Novo = Produto_Novo & "<BLDesc>" & IIf(Upper_Case(Nature_Goods_Samples.ToString()) = "", "N/I", Replace(Upper_Case(Nature_Goods_Samples.ToString()), vbCrLf, "</BLDesc><BLDesc>")) & "</BLDesc>" & vbCrLf

                '            Produto_Novo = Produto_Novo + BLDescr(strProcesso, rsTemp!gmid)
                'INICIO HTS
                Produto_Novo = Produto_Novo & "<Compliance>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ClassificationNumber>" & (Busca_NCM(ProcessoDT.Rows(0)("processo").ToString())) & "</ClassificationNumber> " & vbCrLf
                Produto_Novo = Produto_Novo & " <Domestic-Foreign>D</Domestic-Foreign>"
                Produto_Novo = Produto_Novo & " <DrawbackInd>N</DrawbackInd>"
                Produto_Novo = Produto_Novo & "</Compliance>"
                'FIM HTS
                If ltempDT.Rows(0)("tipo_unid").ToString() = "KG" And lTempDR.Item("quantidade").ToString() < peso_liquido Then
                    Produto_Novo = Produto_Novo & "<BilledQuantity>" & Replace(lTempDR.Item("peso_liquido").ToString(), ",", ".") & "</BilledQuantity>" & vbCrLf
                Else
                    Produto_Novo = Produto_Novo & "<BilledQuantity>" & Replace(lTempDR.Item("quantidade").ToString(), ",", ".") & "</BilledQuantity>" & vbCrLf
                End If

                Produto_Novo = Produto_Novo & "<BilledQuantityUnit>" & IIf(IsDBNull(lTempDR.Item("tipo_unid")) = True, "", lTempDR.Item("tipo_unid").ToString()) & "</BilledQuantityUnit>" & vbCrLf
                Produto_Novo = Produto_Novo & "<Price>" & Replace(lTempDR.Item("preco_unit").ToString(), ",", ".") & "</Price>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ProductAmount>" & Replace(CStr(Replace(CStr(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString()), ".", ",")), ",", ".") & "</ProductAmount>"
                Produto_Novo = Produto_Novo & "<CurrencyCode>" & "USD" & "</CurrencyCode>" & vbCrLf
                Produto_Novo = Produto_Novo & "<CountryofOriginCode>" & Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</CountryofOriginCode>" & vbCrLf
                Produto_Novo = Produto_Novo & "<CountryofOriginName>" & Nome_Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</CountryofOriginName>" & vbCrLf

                If ProcessoDT.Rows(0)("tipo_carga").ToString() <> "BULK" Then
                    Produto_Novo = Produto_Novo & "<NoOfPkgs>" & Replace(CStr(lTempDR.Item("quantidade").ToString() / IIf(lTempDR.Item("capac").ToString() = 0, 1, lTempDR.Item("capac").ToString())), ",", ".") & "</NoOfPkgs>"

                    Produto_Novo = Produto_Novo & "<TypePkgCode>" & IIf(IsDBNull(lTempDR.Item("cd_embalagem")) = True, "", lTempDR.Item("cd_embalagem").ToString()) & "</TypePkgCode>" & vbCrLf

                    Produto_Novo = Produto_Novo & "<TypePkgDesc>" & IIf(IsDBNull(lTempDR.Item("Nome_Tp_Embal")) = True, "", lTempDR.Item("Nome_Tp_Embal").ToString()) & "</TypePkgDesc>" & vbCrLf
                    Produto_Novo = Produto_Novo & "<NoOfPlts>" & Replace(CStr(lTempDR.Item("quantidade").ToString() / IIf(lTempDR.Item("capac").ToString() = 0, 1, lTempDR.Item("capac").ToString())), ",", ".") & "</NoOfPlts>"
                Else
                    Produto_Novo = Produto_Novo & "<NoOfPkgs>" & "</NoOfPkgs>"
                    Produto_Novo = Produto_Novo & "<TypePkgCode>" & "</TypePkgCode>" & vbCrLf
                    Produto_Novo = Produto_Novo & "<TypePkgDesc>" & "</TypePkgDesc>" & vbCrLf
                    Produto_Novo = Produto_Novo & "<NoOfPlts>" & "</NoOfPlts>"
                End If

                'PESO BRUTO
                '            Produto_Novo = Produto_Novo + Produto_Novo_ProdutoCodesName

                Produto_Novo = Produto_Novo & "<Measurements type='GrsWtKgs'>" & vbCrLf

                Produto_Novo = Produto_Novo & "<MeasurementValue>" & CStr(Replace(IIf(IsDBNull(lTempDR.Item("Peso_Bruto").ToString()) = True, 0, lTempDR.Item("Peso_Bruto").ToString()), ",", ".")) & "</MeasurementValue>" & vbCrLf
                Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf
                'PESO LIQUIDO
                Produto_Novo = Produto_Novo & "<Measurements type='NetWtKgs'>" & vbCrLf

                Produto_Novo = Produto_Novo & "<MeasurementValue>" & CStr(Replace(IIf(IsDBNull(lTempDR.Item("peso_liquido").ToString()) = True, 0, lTempDR.Item("peso_liquido").ToString()), ",", ".")) & "</MeasurementValue>" & vbCrLf
                Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf
                'ACUMULADOR PESOS

                PesoLiquido = PesoLiquido + IIf(IsDBNull(lTempDR.Item("peso_liquido").ToString()) = True, 0, lTempDR.Item("peso_liquido").ToString())

                PesoBruto = PesoBruto + IIf(IsDBNull(lTempDR.Item("Peso_Bruto")) = True, 0, lTempDR.Item("Peso_Bruto").ToString())
                Produto_Novo = Produto_Novo & "<PrimaryRptQty>" & Replace(lTempDR.Item("quantidade").ToString(), ",", ".") & "</PrimaryRptQty>"

                Produto_Novo = Produto_Novo & "<PrimaryRptQtyUOM>" & IIf(IsDBNull(lTempDR.Item("tipo_unid")) = True, "", lTempDR.Item("tipo_unid").ToString()) & "</PrimaryRptQtyUOM>"
                Produto_Novo = Produto_Novo & "<SecondaryRptQty>" & Replace(lTempDR.Item("quantidade").ToString(), ",", ".") & "</SecondaryRptQty>"

                Produto_Novo = Produto_Novo & "<SecondaryRptQtyUOM>" & IIf(IsDBNull(lTempDR.Item("tipo_unid")) = True, "", lTempDR.Item("tipo_unid").ToString()) & "</SecondaryRptQtyUOM>"
                Produto_Novo = Produto_Novo & "<EnterValue>" & Replace(CStr(Replace(CStr(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString()), ".", ",")), ",", ".") & "</EnterValue>"
                Produto_Novo = Produto_Novo & "</ProductDetail>"
                Produto_Novo = Produto_Novo & LicenseProduto(strProcesso)
                Produto_Novo = Produto_Novo & SBU(lTempDR.Item("Gmid").ToString())
                Produto_Novo = Produto_Novo & ProductStatement()
                Produto_Novo = Produto_Novo & HazardousDetail(lTempDR.Item("Gmid").ToString())
                Produto_Novo = Produto_Novo & ContainerProduto(strProcesso, lTempDR.Item("Gmid").ToString(), lTempDR.Item("lote").ToString())


                Produto_Novo = Produto_Novo & ProductReferences(strProcesso, lTempDR.Item("Gmid").ToString())

                Produto_Novo = Produto_Novo & ProductsAmounts()
                'Total na RE
                Produto_Novo = Produto_Novo & "<ProductAmounts>"
                Produto_Novo = Produto_Novo & "<ProductAmountType>" & "ReportableValueAmount" & "</ProductAmountType>"
                Produto_Novo = Produto_Novo & "<ProductAmountValue>" & Replace(CStr(Replace(CStr(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString()), ".", ",")), ",", ".") & "</ProductAmountValue>"
                Produto_Novo = Produto_Novo & "<ProductAmountCurrency>" & "USD" & "</ProductAmountCurrency>"
                Produto_Novo = Produto_Novo & "</ProductAmounts>"

                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_DestinationInland()
                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName()
                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_OGA()
                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_HAZ()


                If SBU(lTempDR.Item("Gmid").ToString()) <> "" Then Produto_Novo = Produto_Novo
                'Produto_Novo = Produto_Novo + Duty
                IntI = IntI + 1

                If StrType.Equals("ShippingInstruction") Then
                    Produto_Novo = Produto_Novo & ContainerProdutoInnerPackage(strProcesso, lTempDR.Item("Gmid").ToString())
                End If

                Produto_Novo = Produto_Novo & ProductFees(lTempDR.Item("Gmid").ToString())
                'RsTemp.MoveNext()
                ''           Produto_Novo = Produto_Novo + Produto_Novo_ProdutoCodesName
                'Produto_Novo = Produto_Novo & "</Detail>"


                'Produto_Novo = Produto_Novo & "</Detail>"
                sb.Append(Produto_Novo.ToString())
                sb.Append("</Detail>")
                Produto_Novo = String.Empty
            Next

            Return sb

            '        StrSql = "spINT_Invoice '" & RsProcesso!Processo & "'"
            '        RsTemp.Open StrSql, Conexao, adOpenForwardOnly, adLockReadOnly
            '        While RsTemp.EOF = False
            '            If SBU(RsTemp!gmid) <> "" Then Produto_Novo = Produto_Novo + SBU(RsTemp!gmid)
            '            RsTemp.MoveNext
            '        Wend
        Else

            ltempDT = New DataTable()
            StrSql = "spINT_PEDIDO '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            For Each lTempDR As DataRow In ltempDT.Rows

                Produto_Novo = Produto_Novo & "<Detail>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ProductDetail action='Add'>" & vbCrLf
                Produto_Novo = Produto_Novo & "<LineItemNo>" & CStr(IntI) & "</LineItemNo>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ProductCode>" + lTempDR.Item("Gmid").ToString() + "</ProductCode>" + vbCrLf

                'Cadu 25/07/2023 - Retirada a regra de pegar o NAtureGoods, pois nao estava sendo incluido pelo usuario
                'Produto_Novo = Produto_Novo & "<BrandName><![CDATA[" & IIf(VB.Left(lTempDR.Item("Gmid").ToString(), 1) = "9", Upper_Case(Nature_Goods_Samples), Upper_Case(lTempDR.Item("brandname").ToString())) & "]]></BrandName>" & vbCrLf
                'Produto_Novo = Produto_Novo & "<InvoiceDesc><![CDATA[" & IIf(VB.Left(lTempDR.Item("Gmid").ToString(), 1) = "9", Upper_Case(Replace(Nature_Goods_Samples, vbCrLf, " ")), Upper_Case(lTempDR.Item("brandname").ToString())) & "]]></InvoiceDesc>" + vbCrLf
                'Produto_Novo = Produto_Novo & "<BLDesc><![CDATA[" & Replace(Upper_Case(Nature_Goods_Samples), vbCrLf, "]]></BLDesc><BLDesc><![CDATA[") & "]]></BLDesc>" & vbCrLf


                Produto_Novo = Produto_Novo & "<BrandName><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></BrandName>" & vbCrLf
                Produto_Novo = Produto_Novo & "<InvoiceDesc><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></InvoiceDesc>" & vbCrLf
                Produto_Novo = Produto_Novo & "<BLDesc>" & IIf(Upper_Case(Nature_Goods_Samples.ToString()) = "", "N/I", Replace(Upper_Case(Nature_Goods_Samples.ToString()), vbCrLf, "</BLDesc><BLDesc>")) & "</BLDesc>" & vbCrLf

                '            Produto_Novo = Produto_Novo + BLDescr(strProcesso, rsTemp!gmid)

                'INCIO HTS
                Produto_Novo = Produto_Novo & "<Compliance>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ClassificationNumber>" & Busca_NCM(strProcesso) & "</ClassificationNumber> " & vbCrLf
                Produto_Novo = Produto_Novo & " <Domestic-Foreign>D</Domestic-Foreign>"
                Produto_Novo = Produto_Novo & " <DrawbackInd>N</DrawbackInd>"
                Produto_Novo = Produto_Novo & "</Compliance>"
                'FIM HTS
                Produto_Novo = Produto_Novo & "<BilledQuantity>" & Replace(lTempDR.Item("quantidade").ToString(), ",", ".") & "</BilledQuantity>" & vbCrLf

                Produto_Novo = Produto_Novo & "<BilledQuantityUnit>" + IIf(IsDBNull(lTempDR.Item("tipo_unid")) = True, "", lTempDR.Item("tipo_unid").ToString()) & "</BilledQuantityUnit>" & vbCrLf

                Produto_Novo = Produto_Novo & "<Price>" & Replace(IIf(IsDBNull(lTempDR.Item("preco_unit")) = True, 0, lTempDR.Item("preco_unit").ToString()), ",", ".") & "</Price>" & vbCrLf
                Produto_Novo = Produto_Novo & "<ProductAmount>" & Replace(CStr(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString()), ",", ".") & "</ProductAmount>"
                Produto_Novo = Produto_Novo & "<CurrencyCode>" + lTempDR.Item("cd_Tp_moeda").ToString() + "</CurrencyCode>" + vbCrLf
                Produto_Novo = Produto_Novo & "<CountryofOriginCode>" & Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</CountryofOriginCode>" & vbCrLf
                Produto_Novo = Produto_Novo & "<CountryofOriginName>" & Nome_Pais(ProcessoDT.Rows(0)("cd_org").ToString()) & "</CountryofOriginName>" & vbCrLf
                If (UCase(lTempDR.Item("tipo_unid").ToString()) <> "KG" And UCase(lTempDR.Item("tipo_unid").ToString()) <> "LB") Or UCase(ProcessoDT.Rows(0)("processo").ToString().Substring(1, 1)) <> "A" Then
                    Produto_Novo = Produto_Novo & "<NoOfPkgs>" & Replace(CStr(lTempDR.Item("quantidade").ToString()), ",", "") & "</NoOfPkgs>"

                    Produto_Novo = Produto_Novo & "<TypePkgCode>" & IIf(IsDBNull(lTempDR.Item("cd_dst")) = True, "", lTempDR.Item("cd_dst").ToString()) & "</TypePkgCode>" & vbCrLf

                    Produto_Novo = Produto_Novo & "<TypePkgDesc>" & IIf(IsDBNull(lTempDR.Item("descr_org")) = True, "", lTempDR.Item("descr_org").ToString()) & "</TypePkgDesc>" & vbCrLf
                Else
                    Produto_Novo = Produto_Novo & Produto_Novo_VolAer(strProcesso)
                End If

                'PESO BRUTO

                PesoBrutoProduto = IIf(IsDBNull(lTempDR.Item("peso_bruto_Tot")) = True, 0, lTempDR.Item("peso_bruto_Tot").ToString())

                PesoLiquidoProduto = IIf(IsDBNull(lTempDR.Item("peso_liquido_Tot")) = True, 0, lTempDR.Item("peso_liquido_Tot").ToString())

                If PesoBrutoProduto = 0 Then
                    'If IsDBNull(ltempDT.Rows(0)("Peso_Bruto")) = True Then
                    If String.IsNullOrEmpty(lTempDR.Item("Peso_Bruto").ToString()) = True Then
                        PesoBrutoProduto = 1 * lTempDR.Item("quantidade").ToString()
                        PesoLiquidoProduto = 1 * lTempDR.Item("quantidade").ToString()
                    Else
                        PesoBrutoProduto = lTempDR.Item("Peso_Bruto").ToString() * lTempDR.Item("quantidade").ToString()
                        PesoLiquidoProduto = lTempDR.Item("Peso_Bruto").ToString() * lTempDR.Item("quantidade").ToString()
                    End If
                End If
                '      Produto_Novo = Produto_Novo + Produto_Novo_ProdutoCodesName

                Produto_Novo = Produto_Novo & "<Measurements type='GrsWtKgs'>" & vbCrLf
                Select Case UCase(lTempDR.Item("peso_uom").ToString())
                    Case "LM"
                        PesoBrutoProduto = PesoBrutoProduto * (1000 / 2205)
                        PesoLiquidoProduto = PesoLiquidoProduto * (1000 / 2205)

                    Case "LB"
                        PesoBrutoProduto = PesoBrutoProduto / 2205
                        PesoLiquidoProduto = PesoLiquidoProduto / 2205

                End Select
                'BDPSMART - Conversion failed when converting the varchar value '260.'

                Produto_Novo = Produto_Novo & "<MeasurementValue>" & Replace(CStr(PesoBrutoProduto), ",", ".") & "</MeasurementValue>" & vbCrLf
                Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf
                'PESO LIQUIDO
                Produto_Novo = Produto_Novo & "<Measurements type='NetWtKgs'>" & vbCrLf
                Produto_Novo = Produto_Novo & "<MeasurementValue>" & Replace(CStr(PesoLiquidoProduto), ",", ".") & "</MeasurementValue>" & vbCrLf
                Produto_Novo = Produto_Novo & "</Measurements>" & vbCrLf

                PesoLiquido = PesoLiquido + PesoLiquidoProduto
                PesoBruto = PesoBruto + PesoBrutoProduto
                Produto_Novo = Produto_Novo
                Produto_Novo = Produto_Novo & "<PrimaryRptQty>" & Replace(lTempDR.Item("quantidade").ToString(), ",", ".") & "</PrimaryRptQty>"

                Produto_Novo = Produto_Novo & "<PrimaryRptQtyUOM>" & IIf(IsDBNull(lTempDR.Item("tipo_unid")) = True, "", lTempDR.Item("tipo_unid").ToString()) & "</PrimaryRptQtyUOM>"
                Produto_Novo = Produto_Novo & "<SecondaryRptQty>" & Replace(lTempDR.Item("quantidade").ToString(), ",", ".") & "</SecondaryRptQty>"

                Produto_Novo = Produto_Novo & "<SecondaryRptQtyUOM>" & IIf(IsDBNull(lTempDR.Item("tipo_unid")) = True, "", lTempDR.Item("tipo_unid").ToString()) & "</SecondaryRptQtyUOM>"
                Produto_Novo = Produto_Novo & "<EnterValue>" & Replace(CStr(Replace(CStr(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString()), ".", ",")), ",", ".") & "</EnterValue>"

                Produto_Novo = Produto_Novo & "</ProductDetail>"
                Produto_Novo = Produto_Novo & LicenseProduto(strProcesso)

                If SBU(lTempDR.Item("Gmid").ToString()) <> "" Then Produto_Novo = Produto_Novo & SBU(lTempDR.Item("Gmid").ToString()) 'ltempDT.Rows(0)("Gmid").ToString())
                Produto_Novo = Produto_Novo & ProductStatement()
                Produto_Novo = Produto_Novo & HazardousDetail(lTempDR.Item("Gmid").ToString())
                Produto_Novo = Produto_Novo & ContainerProduto(strProcesso, lTempDR.Item("Gmid").ToString(), lTempDR.Item("lote").ToString())

                Produto_Novo = Produto_Novo & ProductReferences(strProcesso, lTempDR.Item("Gmid").ToString())

                Produto_Novo = Produto_Novo & ProductsAmounts()

                Produto_Novo = Produto_Novo & "<ProductAmounts>"
                Produto_Novo = Produto_Novo & "<ProductAmountType>" & "ReportableValueAmount" & "</ProductAmountType>"
                Produto_Novo = Produto_Novo & "<ProductAmountValue>" & Replace(CStr(Replace(CStr(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString()), ".", ",")), ",", ".") & "</ProductAmountValue>"
                Produto_Novo = Produto_Novo & "<ProductAmountCurrency>" & "USD" & "</ProductAmountCurrency>"
                Produto_Novo = Produto_Novo & "</ProductAmounts>"



                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_DestinationInland()
                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName()
                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_OGA()
                Produto_Novo = Produto_Novo & Produto_Novo_ProdutoCodesName_HAZ()

                Produto_Novo = Produto_Novo & ProductDate(lTempDR.Item("Gmid").ToString())

                If StrType.Equals("ShippingInstruction") Then
                    Produto_Novo = Produto_Novo & ContainerProdutoInnerPackage(strProcesso, lTempDR.Item("Gmid").ToString()) ' ltempDT.Rows(0)("Gmid").ToString())
                End If
                '   Produto_Novo = Produto_Novo + Duty
                Produto_Novo = Produto_Novo & ProductFees(lTempDR.Item("Gmid").ToString())

                IntI = IntI + 1

                'Produto_Novo = Produto_Novo & "</Detail>"
                sb.Append(Produto_Novo.ToString())
                sb.Append("</Detail>")
                Produto_Novo = String.Empty
            Next

            'Produto_Novo_SB.Append(sb)
            Return sb

            '            StrSql = "spINT_PEDIDO '" & RsProcesso!Processo & "'"
            '            RsTemp.Open StrSql, Conexao, adOpenForwardOnly, adLockReadOnly
            '            While RsTemp.EOF = False
            '                If SBU(RsTemp!gmid) <> "" Then Produto_Novo = Produto_Novo + SBU(RsTemp!gmid)
            '                RsTemp.MoveNext
            '            Wend

        End If

    End Function

    Private Function ProductsAmounts() As String


        ProductsAmounts = ""

        ' If UCase(RsProcesso!tipo_carga) = "LCL" Then

        ProductsAmounts = "<ProductAmounts>"
        ProductsAmounts = ProductsAmounts & "<ProductAmountType>" & "CubicMeterMeasurement" & "</ProductAmountType>"
        ProductsAmounts = ProductsAmounts & "<ProductAmountValue>" & Replace(CStr((ProcessoDT.Rows(0)("Vol_Tot").ToString())), ",", ".") & "</ProductAmountValue>"
        ProductsAmounts = ProductsAmounts & "</ProductAmounts>"
        '    End If





    End Function

    Private Function Schedule(ByRef strTipo As String, ByRef StrLocalidade As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "select SCHED_D_K_CD Codigo from SCAC_LOcalidade where Iso_2_LTR_CNTRY_CD='" & Pais(StrLocalidade) & "' and (IATA_3_LTR_CITY_CD='" & StrLocalidade & "' Or UN_LOCTN_CD='" & StrLocalidade & "')"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            If IsDBNull(ltempDT.Rows(0)("codigo")) = True Then
                Schedule = ""
                Exit Function
            End If
            If Trim(ltempDT.Rows(0)("codigo").ToString()) = "" Then
                Schedule = ""
                Exit Function
            End If

            If strTipo = "D" Then
                Schedule = "<OriginCodeType Type='ScheduleD'>" & vbCrLf
                Schedule = Schedule & "<OriginCode>" + ltempDT.Rows(0)("codigo").ToString() + "</OriginCode>" + vbCrLf
                Schedule = Schedule & "</OriginCodeType>"
            Else
                Schedule = "<DestinationCodeType Type='ScheduleK'>" & vbCrLf
                Schedule = Schedule & "<DestinationCode>" + ltempDT.Rows(0)("codigo").ToString() + "</DestinationCode>" + vbCrLf
                Schedule = Schedule & "</DestinationCodeType>"
            End If
        End If


    End Function





    'LEVIS
    Private Function Verifica_Regras_Levis() As String

        Dim sqlCon As New cConexao()
        Dim dtbTemp As New Data.DataTable
        sqlCon.arqINI = "cConexao.ini"
        sqlCon.Conectar()

        Verifica_Regras_Levis = ""

        StrSql = "spSmart_Levis_XML_Rules '" & strProcesso & "'"
        dtbTemp = sqlCon.BuscaInformacoes(StrSql)
        For I As Integer = 0 To dtbTemp.Columns.Count - 1
            If String.IsNullOrEmpty(dtbTemp.Rows(0)(I).ToString) Then
                Verifica_Regras_Levis = dtbTemp.Columns(I).ColumnName
                Exit Function
            End If
        Next

        Return Verifica_Regras_Levis

    End Function

    Private Function BuyerReferenceNumberLevis() As String

        Dim ltempDT As New Data.DataTable
        Dim StrPO As String

        StrPO = ""

        If StrPO = "" Then
            Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
                Case "IM"
                    StrSql = "select numero_po_him Numero from po_him with(nolock)  where num_proc_him='" & strProcesso & "' and (id_dc=9) and numero_po_him <> 'Contract#:00000000' order by id_dc desc"
                Case "IA"
                    StrSql = "select numero_po_hiA Numero from po_hiA with(nolock)  where num_proc_hiA='" & strProcesso & "' and (id_dc=9) and numero_po_hia <> 'Contract#:00000000' order by id_dc desc"
                Case "EA"
                    StrSql = "select numERO_po_hEA Numero from po_hEA with(nolock)  where num_proc_hEA='" & strProcesso & "' and (id_dc=9) and numero_po_hea <> 'Contract#:00000000' order by id_dc desc"
                Case "EM"
                    StrSql = "select numero_po_hEM Numero from po_hEM with(nolock)  where num_proc_hEM='" & strProcesso & "' and (id_dc=9 or id_dc=1) and numero_po_hem <> 'Contract#:00000000' order by id_dc desc"
                Case "IO"
                    StrSql = "select numero_po_hIO Numero from po_hIO with(nolock)  where num_proc_hIO='" & strProcesso & "' and (id_dc=9) and numero_po_hio <> 'Contract#:00000000' order by id_dc desc"
                Case "EO"
                    StrSql = "select numero_po_hEO Numero from po_hEO with(nolock)  where num_proc_hEO='" & strProcesso & "' and (id_dc=9) and numero_po_heo <> 'Contract#:00000000' order by id_dc desc"
            End Select
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            If ltempDT.Rows.Count > 0 Then

                StrPO = IIf(IsDBNull(ltempDT.Rows(0)("numero")) = True, "", (ltempDT.Rows(0)("numero")).ToString())
            Else
                StrPO = ""
            End If
        End If
        StrPO = IIf(StrPO = "", "", Upper_Case(StrPO))
        'strISD = StrPO
        BuyerReferenceNumberLevis = "<References type= 'BuyerReferenceNumber'>" & vbCrLf
        BuyerReferenceNumberLevis = BuyerReferenceNumberLevis & "<ReferenceNumber>" & StrPO & "</ReferenceNumber>" & vbCrLf
        BuyerReferenceNumberLevis = BuyerReferenceNumberLevis & "</References>"

        If BuyerReferenceNumberLevis = "" Then BuyerReferenceNumberLevis = ""

    End Function

    Private Function Busca_SoldTo(ByRef strProcesso As String) As String

        '<Parties type="SoldTo">
        '<Party-Name>SURTIQUIMICOS SA</Party-Name>
        '<Party-Address>CARRERA OCTAVA # 127C - 31</Party-Address>
        '<Party-City>BOGOTA</Party-City>
        '<Party-State-Prov/>
        '<Party-PostalCode/>
        '<Party-Country>CO</Party-Country>
        '<PartyLocation-ID>P000009062</PartyLocation-ID>
        '<Party-CountryName>Colombia</Party-CountryName>
        '<Party-UnlocCode>COBOG</Party-UnlocCode>
        '<GovIDNumber/>
        '</Parties>

        Dim ltempDT As New Data.DataTable

        StrSql = "spSoldTo '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            Busca_SoldTo = "<Parties type=""SoldTo"">" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-Name>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-Name")) = True, "", ltempDT.Rows(0)("Party-Name").ToString())) & "</Party-Name>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-Address>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-Address")) = True, "", ltempDT.Rows(0)("Party-Address").ToString())) & "</Party-Address>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-City>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-City")) = True, "", ltempDT.Rows(0)("Party-City").ToString())) & "</Party-City>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-State-Prov>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-State-Prov")) = True, "", ltempDT.Rows(0)("Party-State-Prov").ToString())) & "</Party-State-Prov>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-PostalCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-PostalCode")) = True, "", ltempDT.Rows(0)("Party-PostalCode").ToString())) & "</Party-PostalCode>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-Country>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-Country")) = True, "", ltempDT.Rows(0)("Party-Country").ToString())) & "</Party-Country>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<PartyLocation-ID>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("PartyLocation-ID")) = True, "", ltempDT.Rows(0)("PartyLocation-ID").ToString())) & "</PartyLocation-ID>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-CountryName>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-CountryName")) = True, "", ltempDT.Rows(0)("Party-CountryName").ToString())) & "</Party-CountryName>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<Party-UnlocCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("Party-UnlocCode")) = True, "", ltempDT.Rows(0)("Party-UnlocCode").ToString())) & "</Party-UnlocCode>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "<GovIDNumber>" & "" & "</GovIDNumber>" & vbCrLf

            Busca_SoldTo = Busca_SoldTo & "</Parties>"

        Else
            Busca_SoldTo = ""
        End If

    End Function

    Private Function ConvertTimeZone(ByVal strDateTime As String, ByRef strTimeZone As String) As String

        Dim timeZoneInfo As TimeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById(strTimeZone)
        Dim dateTime As DateTime = TimeZoneInfo.ConvertTime(Convert.ToDateTime(strDateTime), timeZoneInfo)

        ConvertTimeZone = Convert.ToString(dateTime)

    End Function

    'new 
    Private Function BkngCnfrmtnRcvdSS() As String

        Dim ltempDT As New Data.DataTable

        BkngCnfrmtnRcvdSS = ""

        'If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 1) = "E" Then
        StrSql = "select dt_conclusao from tarefas_processos with(nolock) where num_proc='" + ProcessoDT.Rows(0)("processo").ToString() + "' and id_task=5 and dt_conclusao is not null"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            BkngCnfrmtnRcvdSS = "<Status>" & vbCrLf
            BkngCnfrmtnRcvdSS = BkngCnfrmtnRcvdSS & "<StatusType type='BkngCnfrmtnRcvdSS'/>" + vbCrLf
            BkngCnfrmtnRcvdSS = BkngCnfrmtnRcvdSS & "<StatusDate>" & VB6.Format(ltempDT.Rows(0)("dt_conclusao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
            BkngCnfrmtnRcvdSS = BkngCnfrmtnRcvdSS & "</Status>"
        End If
        'End If


    End Function





    'Cadu - sem vb6
    Private Function Task() As String

        Dim ltempDT As New Data.DataTable
        StrSql = "spInt_Task '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Task = ""
        'RequestedPlantShipDate
        'Previsoes
        For Each lTempDR As DataRow In ltempDT.Rows
            'If IsDBNull(ltempDT.Rows(0)("Smart_Previsao")) = False Then
            If lTempDR.Item("Smart_Previsao").ToString().Length > 0 Then
                Task = Task & "<Status>" & vbCrLf
                Task = Task & "<StatusType type='" + lTempDR.Item("Smart_Previsao").ToString() + "'/>" + vbCrLf
                If lTempDR.Item("Smart_Previsao").ToString() = "RequestedPlantShipDate" Then
                    'Task = Task & "<StatusDate>" & VB6.Format(lTempDR.Item("dt_previsao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    Task = Task & "<StatusDate>" + Convert.ToDateTime(lTempDR.Item("dt_previsao").ToString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
                Else
                    'Task = Task & "<StatusDate>" & VB6.Format(lTempDR.Item("dt_previsao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
                    Task = Task & "<StatusDate>" + Convert.ToDateTime(lTempDR.Item("dt_previsao").ToString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
                End If
                Task = Task & "</Status>"
            End If
        Next


        StrSql = "spInt_Task '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        For Each lTempDR As DataRow In ltempDT.Rows
            'If IsDBNull(lTempDR.Item("Smart_Conclusao")) = False And IsDBNull(lTempDR.Item("dt_conclusao")) = False Then
            If lTempDR.Item("Smart_Conclusao").ToString().Length > 0 And lTempDR.Item("dt_conclusao").ToString().ToString().Length > 0 Then
                Task = Task & "<Status>" & vbCrLf
                Task = Task & "<StatusType type='" + lTempDR.Item("Smart_Conclusao").ToString() + "'/>" + vbCrLf
                'Task = Task & "<StatusDate>" & VB6.Format(lTempDR.Item("dt_conclusao").ToString(), "yyyymmdd") & "</StatusDate>" & vbCrLf
                Task = Task & "<StatusDate>" + Convert.ToDateTime(lTempDR.Item("dt_conclusao").ToString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf

                Task = Task & "</Status>" & vbCrLf
            End If
        Next



    End Function

    Private Function DataCertificadoDeOrigem(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable

        Select Case UCase(strProcesso.Substring(0, 2))
            Case "IM"
                StrSql = "SELECT data_po_him  Data FROM PO_HIM with(nolock) WHERE NUM_PROC_him='" & strProcesso & "' AND ID_DC=13"
            Case "EM"
                StrSql = "SELECT data_po_hem  Data FROM PO_HEM with(nolock)  WHERE NUM_PROC_hem='" & strProcesso & "' AND ID_DC=13"
            Case "EA"
                StrSql = "SELECT data_po_hea  Data FROM PO_HEA with(nolock)  WHERE NUM_PROC_hea='" & strProcesso & "' AND ID_DC=13"
            Case "IA"
                StrSql = "SELECT data_po_hia  Data FROM PO_HiA with(nolock)  WHERE NUM_PROC_hia='" & strProcesso & "' AND ID_DC=13"
            Case "IO"
                StrSql = "SELECT data_po_hio Data FROM PO_HiO with(nolock)  WHERE NUM_PROC_hio='" & strProcesso & "' AND ID_DC=13"
            Case "EO"
                StrSql = "SELECT data_po_heo Data FROM PO_HEO with(nolock)  WHERE NUM_PROC_hEo='" & strProcesso & "' AND ID_DC=13"

        End Select

        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            If ltempDT.Rows(0)("Data").ToString().Length > 0 Then
                DataCertificadoDeOrigem = "<Status>" & vbCrLf
                DataCertificadoDeOrigem = DataCertificadoDeOrigem & "<StatusType type='CertOriginApplied' />" & vbCrLf
                'DataCertificadoDeOrigem = DataCertificadoDeOrigem & "<StatusDate>" & (VB6.Format(CDate(ltempDT.Rows(0)("Data").ToString()), "yyyymmdd")) & "</StatusDate>" & vbCrLf
                DataCertificadoDeOrigem = DataCertificadoDeOrigem & "<StatusDate>" + Convert.ToDateTime(ltempDT.Rows(0)("Data").ToString()).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
                DataCertificadoDeOrigem = DataCertificadoDeOrigem & "</Status>"
            End If
        End If


    End Function

    Private Function Container_Renamed() As String

        Dim ltempDT As New Data.DataTable

        If String.Compare(StrType, "301", True) <> 0 Then
            'If StrType <> "301" Then
            Select Case ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2)
            'Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
                Case "EM"
                    StrSql = "select cd_smart,cm.cd_tp_cont,nome_tp_cont,count(ch.item_cont_em) Qty from container_mas_exp_mar CM with(nolock)" & " Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont" & " Join container_hou_exp_mar  ch with(nolock) on ch.num_proc_mem=cm.num_proc_mem and ch.item_cont_em=cm.item_cont_em" & " where num_proc_hem='" & ProcessoDT.Rows(0)("processo").ToString() & "'" & " Group by cd_smart,cm.cd_tp_cont,nome_tp_cont"
                Case "IM"
                    StrSql = "select cd_smart,cm.cd_tp_cont,nome_tp_cont,count(ch.item_cont_im) Qty from container_mas_imp_mar CM with(nolock)" & " Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont" & " Join container_hou_imp_mar ch with(nolock) on ch.num_proc_mim=cm.num_proc_mim and ch.item_cont_im=cm.item_cont_im" & " where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "'" & " Group by cd_smart,cm.cd_tp_cont,nome_tp_cont"
                Case "IO"
                    StrSql = "select cd_smart,cm.cd_tp_cont,nome_tp_cont,count(ch.item_cont_im) Qty from container_mas_imp_mar CM with(nolock)" & " Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont" & " Join container_hou_imp_mar ch with(nolock) on ch.num_proc_mim=cm.num_proc_mim and ch.item_cont_im=cm.item_cont_im" & " where num_proc_him='" & ProcessoDT.Rows(0)("processo").ToString() & "'" & " Group by cd_Smart,cm.cd_tp_cont,nome_tp_cont"
                Case "IA", "EA"
                    StrSql = "select '' cd_smart,'LCL' cd_tp_cont,'LCL' nome_tp_cont,0  Qty "

            End Select
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            Container_Renamed = ""
            If ltempDT.Rows.Count > 0 Then
                If String.Compare(ltempDT.Rows(0)("cd_tp_cont").ToString(), "LCL", True) = 0 Or String.Compare(ltempDT.Rows(0)("cd_tp_cont").ToString(), "LCM", True) = 0 Then
                    'If (ltempDT.Rows(0)("cd_tp_cont").ToString() = "LCL" Or ltempDT.Rows(0)("cd_tp_cont").ToString() = "LCM") Then
                    Container_Renamed = Container_Renamed & "<EquipmentSummary>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentQuantity></EquipmentQuantity>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentSize></EquipmentSize>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentContainerTypeRequest>C</EquipmentContainerTypeRequest>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentType></EquipmentType>" & vbCrLf
                    'Container_Renamed = Container_Renamed & "<EquipmentDescription>" + ltempDT.Rows(0)("nome_tp_cont").ToString() + " </EquipmentDescription>" + vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentDescription>" + IIf(String.Compare(ltempDT.Rows(0)("cd_tp_cont").ToString(), "LCL", True) = 0, ltempDT.Rows(0)("cd_tp_cont").ToString(), ltempDT.Rows(0)("nome_tp_cont").ToString()) + "</EquipmentDescription>" + vbCrLf
                    Container_Renamed = Container_Renamed & "<SubstituteEquipmentDescription></SubstituteEquipmentDescription>" & vbCrLf
                    Container_Renamed = Container_Renamed & "</EquipmentSummary>"
                Else
                    For Each ltempDR As DataRow In ltempDT.Rows
                        Container_Renamed = Container_Renamed & "<EquipmentSummary>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentQuantity>" & CStr(ltempDR.Item("Qty").ToString()) & "</EquipmentQuantity>" & vbCrLf
                        'Container_Renamed = Container_Renamed & "<EquipmentSize>" & VB.Left(ltempDR.Item("cd_tp_cont").ToString(), 2) & "</EquipmentSize>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentSize>" & ltempDR.Item("cd_tp_cont").ToString().Substring(0, 2) & "</EquipmentSize>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentContainerTypeRequest>C</EquipmentContainerTypeRequest>" & vbCrLf

                        'Container_Renamed = Container_Renamed & "<EquipmentType>" & IIf(IsDBNull(ltempDR.Item("cd_smart")) = True, "", ltempDT.Rows(0)("cd_smart").ToString()) & "</EquipmentType>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentType>" & IIf(ltempDR.Item("cd_smart").ToString().Length = 0, "", ltempDT.Rows(0)("cd_smart").ToString()) & "</EquipmentType>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentDescription>" & ltempDR.Item("nome_tp_cont").ToString() & "</EquipmentDescription>" + vbCrLf
                        Container_Renamed = Container_Renamed & "<SubstituteEquipmentDescription></SubstituteEquipmentDescription>" & vbCrLf
                        Container_Renamed = Container_Renamed & "</EquipmentSummary>" & vbCr
                    Next

                End If
            End If
        Else
            StrSql = "sp301_Equipment_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)
            Container_Renamed = ""
            If ltempDT.Rows.Count > 0 Then
                If String.Compare(ltempDT.Rows(0)("cd_tp_cont").ToString(), "FCL", True) = 0 Then
                    'If (ltempDT.Rows(0)("cd_tp_cont").ToString() = "FCL") Then
                    For Each ltempDR As DataRow In ltempDT.Rows
                        Container_Renamed = Container_Renamed & "<EquipmentSummary>" & vbCrLf
                        'If String.Compare(StrPais, "Argentina", True) = 0 Or String.Compare(strTipo, "301", True) = 0 Then
                        '    'If StrPais = "Argentina" And strTipo = "301" Then
                        '    Container_Renamed = Container_Renamed & "<EquipmentQuantity>" & CStr("1") & "</EquipmentQuantity>" & vbCrLf
                        'Else
                        Container_Renamed = Container_Renamed & "<EquipmentQuantity>" & CStr(ltempDR.Item("EquipmentQuantity").ToString()) & "</EquipmentQuantity>" & vbCrLf
                        'End If
                        'Container_Renamed = Container_Renamed & "<EquipmentSize>" & VB.Left(ltempDR.Item("EquipmentSize").ToString(), 2) & "</EquipmentSize>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentSize>" & ltempDR.Item("EquipmentSize").ToString().Substring(0, 2) & "</EquipmentSize>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentContainerTypeRequest>ADD</EquipmentContainerTypeRequest>" & vbCrLf
                        Container_Renamed = Container_Renamed & "<EquipmentType>" & CStr(ltempDR.Item("EquipmentType").ToString()) & "</EquipmentType>" & vbCrLf
                        'Container_Renamed = Container_Renamed & "<EquipmentDescription>" & lTempDT.Rows(0)("nome_tp_cont").toString() & "</EquipmentDescription>" + vbCrLf
                        'Container_Renamed = Container_Renamed & "<SubstituteEquipmentDescription></SubstituteEquipmentDescription>" & vbCrLf
                        Container_Renamed = Container_Renamed & "</EquipmentSummary>" & vbCr
                    Next
                Else
                    Container_Renamed = Container_Renamed & "<EquipmentSummary>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentQuantity></EquipmentQuantity>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentSize></EquipmentSize>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentContainerTypeRequest>C</EquipmentContainerTypeRequest>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentType></EquipmentType>" & vbCrLf
                    Container_Renamed = Container_Renamed & "<EquipmentDescription>" + ltempDT.Rows(0)("cd_tp_cont").ToString() + " </EquipmentDescription>" + vbCrLf
                    Container_Renamed = Container_Renamed & "<SubstituteEquipmentDescription></SubstituteEquipmentDescription>" & vbCrLf
                    Container_Renamed = Container_Renamed & "</EquipmentSummary>"
                End If
            End If
        End If

    End Function

    Private Function STOInd() As String

        Dim ltempDT As New Data.DataTable
        StrSql = "spCampo_Ordem_STOY_Sel '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        STOInd = String.Empty
        If ltempDT.Rows.Count > 0 Then
            'If ltempDT.Rows(0)("STO Indicator").ToString().Length > 0 Then
            STOInd = "<References type='STOInd'>"
            STOInd = STOInd & "<ReferenceNumber><![CDATA[" + ltempDT.Rows(0)("STO Indicator").ToString() + "]]></ReferenceNumber>"
            STOInd = STOInd & " </References>"
            'End If
        End If

        Return STOInd
    End Function


    Private Function Data_DeadLine() As String

        Dim dl_carga As String

        If String.Compare(ProcessoDT.Rows(0)("processo").ToString().Substring(0, 2), "EM", True) = 0 Then
            If ProcessoDT.Rows(0)("dl_carga").ToString().Length > 0 And String.Compare(ProcessoDT.Rows(0)("Cd_tp_carga").ToString(), "3", True) <> 0 Then

                'If IsDBNull(ProcessoDT.Rows(0)("dl_carga").ToString()) = False Then
                If String.Compare(StrType, "301", True) = 0 Then
                    'If StrType = "301" Then
                    dl_carga = ConvertTimeZone(ProcessoDT.Rows(0)("dl_carga").ToString().ToString, "Eastern Standard Time")
                Else
                    dl_carga = ProcessoDT.Rows(0)("dl_carga").ToString().ToString
                End If

                Data_DeadLine = "<Status>" & vbCrLf
                Data_DeadLine = Data_DeadLine & "<StatusType type='LatestDeliveryDate'/>" & vbCrLf
                'Data_DeadLine = Data_DeadLine & "<StatusDate>" & VB6.Format(dl_carga, "yyyymmdd") & "</StatusDate>" & vbCrLf
                Data_DeadLine = Data_DeadLine & "<StatusDate>" + Convert.ToDateTime(dl_carga).ToString("yyyyMMdd") + "</StatusDate>" & vbCrLf
                'If VB6.Format(ProcessoDT.Rows(0)("dl_carga").ToString(), "hhmm") = "0000" Then
                If String.Compare(Convert.ToDateTime(ProcessoDT.Rows(0)("dl_carga").ToString()).ToString("HHmm"), "0000", True) = 0 Then
                    Data_DeadLine = Data_DeadLine & "<StatusTime></StatusTime>" & vbCrLf
                Else
                    'Data_DeadLine = Data_DeadLine & "<StatusTime>" & VB6.Format(dl_carga, "hhmm") & "</StatusTime>" & vbCrLf
                    Data_DeadLine = Data_DeadLine & "<StatusTime>" + Convert.ToDateTime(dl_carga).ToString("HHmm") + "</StatusTime>" & vbCrLf
                End If
                Data_DeadLine = Data_DeadLine & "</Status>"
            Else
                Data_DeadLine = ""
            End If
        End If

    End Function

    Private Function FreightAmount() As String

        Dim ltempDT As New Data.DataTable
        Dim EquipmentQuantity As String = ""
        Dim vlr_frete As String = ""

        FreightAmount = "<ReferenceType type='FreightAmount'>"

        vlr_frete = IIf(IsDBNull(ProcessoDT.Rows(0)("vlr_frete")) = True, 0, ProcessoDT.Rows(0)("vlr_frete").ToString())

        StrSql = "sp301_Equipment_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count > 0 Then
            EquipmentQuantity = CStr(vlr_frete / ltempDT.Rows(0)("EquipmentQuantity").ToString())
        Else
            EquipmentQuantity = vlr_frete
        End If

        Dim dec As Decimal
        dec = Decimal.Parse(EquipmentQuantity)
        EquipmentQuantity = dec.ToString("0.00")

        FreightAmount = FreightAmount & "<ReferenceNumber>" & Replace(EquipmentQuantity, ",", ".") & "</ReferenceNumber>" & vbCrLf
        FreightAmount = FreightAmount & "</ReferenceType>" & vbCrLf

    End Function

    Private Function ContainerProdutoInnerPackage(ByRef strProcesso As String, ByRef strPRoduto As String) As String

        Dim ltempDT As New Data.DataTable

        StrSql = "spSmartProdutoContainer_Volume_INT '" & strProcesso & "','" & strPRoduto & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        ContainerProdutoInnerPackage = ""
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows
            ContainerProdutoInnerPackage = ContainerProdutoInnerPackage & "<InnerPackage>"
            ContainerProdutoInnerPackage = ContainerProdutoInnerPackage & "<PackageType>" & CStr(lTempDR.Item("PackageType").ToString()) & "</PackageType>"
            ContainerProdutoInnerPackage = ContainerProdutoInnerPackage & "<PackageCount>" & CStr(lTempDR.Item("PackageCount").ToString()) & "</PackageCount>"
            ContainerProdutoInnerPackage = ContainerProdutoInnerPackage & "</InnerPackage>"
        Next

        ' <InnerPackage>
        '  <PackageType>ROLLS</PackageType>
        '  <PackageCount>22</PackageCount>
        '</InnerPackage>

    End Function
    Private Function CarrierAgntNewPrty(ByRef strPartiesType As String, ByRef strProcesso As String) As String

        ' <Parties type = "CarrierAgntNewPrty" >
        '   <Party-Name>HAPAG-LLOYD</Party-Name>
        '	<Party-Address/>
        '	<Party-City>SANTOS</Party-City>
        '	<Party-State-Prov/>
        '	<Party-PostalCode/>
        '	<Party-Country/>
        '	<Party-ID/>
        '	<PartyLocation-ID>BRSSZ</PartyLocation-ID>
        '	<Party-GlobalCode/>
        '</Parties>

        Dim ltempDT As New Data.DataTable

        StrSql = "select ARM.Nome_Armador, Org.Nome_Local,'BR'+ORG.Cd_Local PartyLocation from vwHouse_Exp HOU  with(nolock)	
            join Armador ARM with(nolock) on ARM.Cd_Armador = HOU.Cd_Armador 
            join Localidade ORG with(nolock) on ORG.Cd_Local = HOU.Cd_Org 
            where	Hou.Num_Proc= '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        CarrierAgntNewPrty = ""
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows
            CarrierAgntNewPrty = "<Parties type=" + ControlChars.Quote + strPartiesType + ControlChars.Quote + ">" & vbCrLf
            'CarrierAgntNewPrty = "<Parties type=" + "'" + strPartiesType + "'" + ">" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-Name>" & CStr(lTempDR.Item("Nome_Armador").ToString()) & "</Party-Name>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-Address/>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-City>" & CStr(lTempDR.Item("Nome_Local").ToString()) & "</Party-City>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-State-Prov/>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-PostalCode/>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-Country/>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-ID/>" & vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<PartyLocation-ID>" & CStr(lTempDR.Item("PartyLocation").ToString()) & "</PartyLocation-ID>" + vbCrLf
            CarrierAgntNewPrty = CarrierAgntNewPrty & "<Party-GlobalCode/>"
            CarrierAgntNewPrty = CarrierAgntNewPrty & "</Parties>"
        Next

    End Function

    Private Function BookingNumberSI() As String

        BookingNumberSI = ""
        BookingNumberSI = "<References type= 'BookingNumber'>" & vbCrLf
        BookingNumberSI = BookingNumberSI & "<ReferenceNumber>" + IIf(IsDBNull(ProcessoDT.Rows(0)("nr_reserva")) = True, "", UCase(ProcessoDT.Rows(0)("nr_reserva").ToString())) + "</ReferenceNumber>" + vbCrLf
        BookingNumberSI = BookingNumberSI & "<ReferenceDate>" & "</ReferenceDate>" & vbCrLf
        BookingNumberSI = BookingNumberSI & "</References>"

    End Function

    Private Function CarrierContractNbrSI() As String

        CarrierContractNbrSI = ""
        CarrierContractNbrSI = "<References type= 'CarrierContractNbr'>" & vbCrLf
        Dim ltempDT As New Data.DataTable
        StrSql = "select Contract_Number Value from Booking_Request where num_proc = '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows
            CarrierContractNbrSI = CarrierContractNbrSI & "<ReferenceNumber>" & CStr(lTempDR.Item("Value").ToString()) & "</ReferenceNumber>" & vbCrLf
        Next
        CarrierContractNbrSI = CarrierContractNbrSI & "</References>"

    End Function

    Private Function Shipper_Reference_NumberSI() As String

        Shipper_Reference_NumberSI = ""
        Shipper_Reference_NumberSI = "<References type= 'Shipper_Reference_Number'>" & vbCrLf
        Dim ltempDT As New Data.DataTable
        StrSql = "select Shipper_Reference_Number Value from Booking_Request where num_proc = '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows
            Shipper_Reference_NumberSI = Shipper_Reference_NumberSI & "<ReferenceNumber>" & CStr(lTempDR.Item("Value").ToString()) & "</ReferenceNumber>" & vbCrLf
        Next
        Shipper_Reference_NumberSI = Shipper_Reference_NumberSI & "</References>"

    End Function

    Private Function Forwarder_Reference_NumberSI() As String

        Forwarder_Reference_NumberSI = ""
        Forwarder_Reference_NumberSI = "<References type= 'Forwarder_Reference_Number'>" & vbCrLf
        Dim ltempDT As New Data.DataTable
        StrSql = "select Forwarder_Reference_Number Value from Booking_Request where num_proc = '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows
            Forwarder_Reference_NumberSI = Forwarder_Reference_NumberSI & "<ReferenceNumber>" & CStr(lTempDR.Item("Value").ToString()) & "</ReferenceNumber>" & vbCrLf
        Next
        Forwarder_Reference_NumberSI = Forwarder_Reference_NumberSI & "</References>"

    End Function

    Private Function Transportation_TypeofMoveCodeSI() As String

        Transportation_TypeofMoveCodeSI = ""
        Dim ltempDT As New Data.DataTable
        StrSql = "select B.Cd_Tp_Move , T.Nome_Tp_Move Nome_Tp_Move from Booking_Request B with(nolock) join Tipo_Move T with(nolock) on T.Cd_Tp_Move = B.Cd_Tp_Move where num_proc = '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)
        If ltempDT.Rows.Count = 0 Then Exit Function
        For Each lTempDR As DataRow In ltempDT.Rows
            Transportation_TypeofMoveCodeSI = Transportation_TypeofMoveCodeSI + "<TypeofMoveCode Type=" + ControlChars.Quote + CStr(lTempDR.Item("Cd_Tp_Move").ToString()) + ControlChars.Quote + "/>" & vbCrLf
            Transportation_TypeofMoveCodeSI = Transportation_TypeofMoveCodeSI + "<TypeofMoveDescription>" + CStr(lTempDR.Item("Nome_Tp_Move").ToString()) + "</TypeofMoveDescription>" & vbCrLf
        Next


    End Function

    'writer.WriteStartElement("TypeofMoveCode");
    '      writer.WriteAttributeString("Type", tMain.Cd_Tp_Move);
    '      writer.WriteEndElement();//TypeofMoveCode

    Private Function MasterBillOfLadingSI() As String

        MasterBillOfLadingSI = ""
        MasterBillOfLadingSI = "<References type= 'MasterBillOfLading'>" & vbCrLf
        MasterBillOfLadingSI = MasterBillOfLadingSI & "<ReferenceNumber>" + ProcessoDT.Rows(0)("mawb").ToString() + "</ReferenceNumber>" + vbCrLf
        MasterBillOfLadingSI = MasterBillOfLadingSI & "</References>"

    End Function

    Private Function HouseCarrierSCACSI(ByRef strProcesso As String) As String

        Dim ltempDT As New Data.DataTable
        HouseCarrierSCACSI = ""
        StrSql = "select ARM.Scac Value from vwHouse_Exp HOU  with(nolock)	
            join Armador ARM with(nolock) on ARM.Cd_Armador = HOU.Cd_Armador            
            where	Hou.Num_Proc= '" & strProcesso & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then
            HouseCarrierSCACSI = HouseCarrierSCACSI + "<ReferenceType type='HouseCarrierSCAC'>" + vbCrLf
            HouseCarrierSCACSI = HouseCarrierSCACSI + "<ReferenceNumber>" + ltempDT.Rows(0)("Value").ToString() + "</ReferenceNumber>" + vbCrLf
            HouseCarrierSCACSI = HouseCarrierSCACSI + "</ReferenceType>" + vbCrLf

            HouseCarrierSCACSI = HouseCarrierSCACSI + "<ReferenceType type='HouseCarrier'>" + vbCrLf
            HouseCarrierSCACSI = HouseCarrierSCACSI + "<ReferenceNumber>" + ltempDT.Rows(0)("Value").ToString() + "</ReferenceNumber>" + vbCrLf
            HouseCarrierSCACSI = HouseCarrierSCACSI + "</ReferenceType>" + vbCrLf
        End If
    End Function

    Private Function DocumentsSI() As String

        DocumentsSI = ""
        DocumentsSI = "<Documents>" & vbCrLf
        DocumentsSI = DocumentsSI & "<DocumentType>" & "Bill Of lading original" & "</DocumentType>"
        DocumentsSI = DocumentsSI & "<DocumentDesc>" & "Document Not freighted" & "</DocumentDesc>"
        DocumentsSI = DocumentsSI & "<OriginalOrCopy>" & "3" & "</OriginalOrCopy>"
        DocumentsSI = DocumentsSI & "<DocumentNumber>" + "" + "</DocumentNumber>" + vbCrLf
        DocumentsSI = DocumentsSI & "</Documents>"

        '  <Documents>
        '  <DocumentType>Bill Of lading original</DocumentType>
        '  <DocumentDesc>Document Not freighted</DocumentDesc>
        '  <OriginalOrCopy>3</OriginalOrCopy>
        '  <DocumentNumber />
        '</Documents>

    End Function

    Private Function ForwarderSI() As String

        Dim ltempDT As New Data.DataTable

        Select Case StrPais
            Case "Argentina"
                StrSql = "spintPessoa_Sel 'P15498'"
                If strArgTP = "SEA" Then
                    StrSql = "spintPessoa_Sel 'P4'"
                End If
            Case "Brasil"
                StrSql = "spintPessoa_Sel '10017'"
            Case "Chile"
                StrSql = "spintPessoa_Sel 'P10050'"

        End Select
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        ForwarderSI = "<Parties type=""Forwarder"">" & vbCrLf
        ForwarderSI = ForwarderSI & "<Party-Name>" & Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString()) & "</Party-Name>" & vbCrLf

        ForwarderSI = ForwarderSI & "<Party-Address>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("endereco")) = True, "", ltempDT.Rows(0)("endereco").ToString())) & "</Party-Address>" & vbCrLf

        ForwarderSI = ForwarderSI & "<Party-City>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cidade")) = True, "", ltempDT.Rows(0)("cidade").ToString())) & "</Party-City>" & vbCrLf

        ForwarderSI = ForwarderSI & "<Party-State-Prov>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("uf")) = True, "", ltempDT.Rows(0)("uf").ToString())) & "</Party-State-Prov>" & vbCrLf

        ForwarderSI = ForwarderSI & "<Party-PostalCode>" & Upper_Case(IIf(IsDBNull(ltempDT.Rows(0)("cep")) = True, "", ltempDT.Rows(0)("cep").ToString())) & "</Party-PostalCode>" & vbCrLf
        Select Case StrPais
            Case "Argentina"
                ForwarderSI = ForwarderSI & "<Party-Country>AR</Party-Country>" & vbCrLf
                ForwarderSI = ForwarderSI & "<Party-ID type=""PartnerID"">BDPARBUE</Party-ID>"
            Case "Brasil"
                ForwarderSI = ForwarderSI & "<Party-Country>BR</Party-Country>" & vbCrLf
                ForwarderSI = ForwarderSI & "<Party-ID type=""PartnerID"">BDPBRSAO</Party-ID>"
            Case "Chile"
                ForwarderSI = ForwarderSI & "<Party-Country>BR</Party-Country>" & vbCrLf
                ForwarderSI = ForwarderSI & "<Party-ID type=""PartnerID"">BDPCLSCL</Party-ID>"
        End Select
        ForwarderSI = ForwarderSI & CSR_Contact()
        ForwarderSI = ForwarderSI & "</Parties>"

    End Function



    Private Function Pessoa_Altera_BL(ByRef strProcesso As String, ByRef strField As String) As String

        '<Party-Name>BDP ASIA PACIFIC LIMITED</Party-Name>
        ' <Party-Address>UNIT 705-08, 7/F., MAGNET PLACE,</Party-Address>
        ' <Party-Address>TOWER ONE, 77-81 CONTAINER PORT</Party-Address>
        ' <Party-Address>ROAD, KWAI CHUNG, HONG KONG</Party-Address>

        Pessoa_Altera_BL = ""

        Dim ltempDT As New Data.DataTable

        StrSql = "spPessoa_Altera_BL_Sel '" & ProcessoDT.Rows(0)("processo").ToString() & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count > 0 Then

            Dim texto As String = ltempDT.Rows(0)($"{strField}").ToString()

            Dim linhas As String() = texto.Split({vbCrLf}, StringSplitOptions.RemoveEmptyEntries)

            ' Iterando pelas linhas usando o loop for
            For i As Integer = 0 To linhas.Length - 1
                Console.WriteLine("Linha " & (i + 1) & ": " & linhas(i))
                If i = 0 Then
                    Pessoa_Altera_BL = Pessoa_Altera_BL & "<Party-Name>" & linhas(i) & "</Party-Name>" & vbCrLf
                Else
                    Pessoa_Altera_BL = Pessoa_Altera_BL & "<Party-Address>" & linhas(i) & "</Party-Address>" & vbCrLf
                End If
            Next
            Pessoa_Altera_BL = Pessoa_Altera_BL & "<Party-City />" & vbCrLf

            Pessoa_Altera_BL = Pessoa_Altera_BL & "<Party-State-Prov />" & vbCrLf

            Pessoa_Altera_BL = Pessoa_Altera_BL & "<Party-PostalCode />" & vbCrLf

            Pessoa_Altera_BL = Pessoa_Altera_BL & "<Party-Country />" & vbCrLf

            Pessoa_Altera_BL = Pessoa_Altera_BL & "<PartyLocation-ID />" & vbCrLf

            Pessoa_Altera_BL = Pessoa_Altera_BL & "<GovIDNumber />" & vbCrLf

        Else
            Pessoa_Altera_BL = ""
        End If

    End Function


    Private Function ProductReferences(ByRef strProcesso As String, ByRef strProduto As String) As String

        Dim ltempDT As New Data.DataTable

        ProductReferences = ""

        StrSql = "spINT_ProductReferences_Sel '" & strProcesso & "' , '" & strProduto & "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        If ltempDT.Rows.Count = 0 Then Exit Function

        For Each lTempDR As DataRow In ltempDT.Rows
            ProductReferences = ProductReferences & "<ProductReferences type=" + ControlChars.Quote + CStr(lTempDR.Item("ProductReferencesType").ToString()) + ControlChars.Quote + ">" & vbCrLf
            ProductReferences = ProductReferences & "<ProductReferenceNumber>" + CStr(lTempDR.Item("ProductReferences").ToString()) + "</ProductReferenceNumber>"
            ProductReferences = ProductReferences & "</ProductReferences>"
        Next

    End Function



    'ODS New 24/05/2024
    Private Function Invoice() As String

        Dim ltempDT As New Data.DataTable
        Dim fltTotalInvoice As Decimal
        Dim vlr_frete As Decimal

        Dim lCabecalho As New Data.DataTable
        Dim StrDetalhe As String
        Dim strMoeda As String
        Dim intSeq As Short

        StrSql = "select dbo.fBusca_TipoDocCliente('D','" + ProcessoDT.Rows(0)("processo").ToString() + "',1) Data"
        lCabecalho = sqlCnn.BuscaInformacoes(StrSql)

        glbfltTotalInvoice = 0

        StrSql = "spINT_PEDIDO '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
        ltempDT = sqlCnn.BuscaInformacoes(StrSql)

        Invoice = ""

        If ltempDT.Rows.Count = 0 Then
            StrSql = "spINTSmart_CommercialInvoice '" + ProcessoDT.Rows(0)("processo").ToString() + "'"
            ltempDT = sqlCnn.BuscaInformacoes(StrSql)

            Invoice = "<CommercialInvoice>" & vbCrLf
            Invoice = Invoice & "<InvoiceNumber>" & Invoice_STR() & "</InvoiceNumber>" & vbCrLf

            If IsDBNull(ProcessoDT.Rows(0)("cd_tp_oper")) = False Then

                Invoice = Invoice & "<TermsofSaleCode>" + ProcessoDT.Rows(0)("cd_tp_oper").ToString() + "</TermsofSaleCode>" + vbCrLf
                'Invoice = Invoice & "<TermsofSaleDesc>" & Incoterm(ProcessoDT.Rows(0)("cd_tp_oper").toString()) & "</TermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<TermsofSaleDesc>" & ProcessoDT.Rows(0)("cd_tp_oper").ToString() & "</TermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<FinalTermsofSaleCode>" + ProcessoDT.Rows(0)("cd_tp_oper").ToString() + "</FinalTermsofSaleCode>" + vbCrLf
                'Invoice = Invoice & "<FinalTermsofSaleDesc>" & Incoterm(ProcessoDT.Rows(0)("cd_tp_oper").toString()) & "</FinalTermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<FinalTermsofSaleDesc>" & ProcessoDT.Rows(0)("cd_tp_oper").ToString() & "</FinalTermsofSaleDesc>" & vbCrLf
                Dim Cd_Termo As String
                Cd_Termo = IIf(IsDBNull(ltempDT.Rows(0)("cd_termo").ToString()), "", CStr(ltempDT.Rows(0)("cd_termo").ToString()))
                Dim Termo As String
                Termo = IIf(IsDBNull(ltempDT.Rows(0)("termo").ToString()), "", CStr(ltempDT.Rows(0)("termo").ToString()))
                Invoice = Invoice & "<TermsofPaymentCode>" & Cd_Termo & "</TermsofPaymentCode>" & vbCrLf
                Invoice = Invoice & "<TermsofPaymentDescription>" + Termo + "</TermsofPaymentDescription>"

            End If

            If lCabecalho.Rows.Count > 0 Then
                Invoice = Invoice & "<InvoiceAmount>" & "valor_invoice" & "</InvoiceAmount>"
                Invoice = Invoice & "<CurrencyCode>" + ltempDT.Rows(0)("cd_Tp_moeda").ToString() + "</CurrencyCode>"
                Invoice = Invoice & "<CIDate>" & VB6.Format(VB.Left(lCabecalho.Rows(0)("Data").ToString(), 10), "yyyyMMdd") & "</CIDate>"
            End If


            StrDetalhe = ""
            fltTotalInvoice = 0
            intSeq = 1
            For Each lTempDR As DataRow In ltempDT.Rows
                strMoeda = UCase(lTempDR.Item("cd_Tp_moeda").ToString())
                Dim TotalInfoice As String
                TotalInfoice = IIf(lTempDR.Item("Vlr_Invoice").ToString().Length = 0, "0", CStr(lTempDR.Item("Vlr_Invoice").ToString()))
                'fltTotalInvoice = lTempDR.Item("Vlr_Invoice").ToString().Length = 0 ? 0: lTempDR.Item("Vlr_Invoice").ToString()
                fltTotalInvoice = TotalInfoice
                'StrDetalhe = StrDetalhe & "<CIProductDetail action='Add'>"
                'StrDetalhe = StrDetalhe & "<LineItemNo>" & CStr(intSeq) & "</LineItemNo>"
                'StrDetalhe = StrDetalhe & "<ProductCode>" + lTempDR.Item("Gmid").ToString() + "</ProductCode>"
                'StrDetalhe = StrDetalhe & "<BrandName><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></BrandName>"
                'StrDetalhe = StrDetalhe & "<InvoiceDesc><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></InvoiceDesc>"
                'StrDetalhe = StrDetalhe & "<BilledQuantity>" & Replace(CStr(VB6.Format(lTempDR.Item("quantidade").ToString(), "0.00")), ",", ".") & "</BilledQuantity>" & vbCrLf
                'StrDetalhe = StrDetalhe & "<BilledQuantityUnit>" & Upper_Case(lTempDR.Item("tipo_unid").ToString()) & "</BilledQuantityUnit>"
                'StrDetalhe = StrDetalhe & "<Price>" & Replace(CStr(VB6.Format(lTempDR.Item("preco_unit").ToString(), "0.00")), ",", ".") & "</Price>" & vbCrLf
                'StrDetalhe = StrDetalhe & "<PriceCurrency>" & UCase(lTempDR.Item("cd_Tp_moeda").ToString()) & "</PriceCurrency>"
                'StrDetalhe = StrDetalhe & "<Amount>" & Replace(CStr(VB6.Format(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString(), "0.00")), ",", ".") & "</Amount>"
                'StrDetalhe = StrDetalhe & "<AmountCurrency>" & UCase(lTempDR.Item("cd_Tp_moeda").ToString()) & "</AmountCurrency>"

                'StrDetalhe = StrDetalhe & "</CIProductDetail>"

                intSeq = intSeq + 1

            Next

            If ProcessoDT.Rows(0)("vlr_frete").ToString().Length = 0 Then
                vlr_frete = 0
            Else
                vlr_frete = ProcessoDT.Rows(0)("vlr_frete").ToString()
            End If

            Invoice = Replace(Invoice, "valor_invoice", Replace(CStr(fltTotalInvoice), ",", "."))
            If vlr_frete < fltTotalInvoice Then
                fltTotalInvoice = fltTotalInvoice - vlr_frete
            End If
            Invoice = Invoice & "<FOBAmount>" & Replace(CStr(fltTotalInvoice), ",", ".") & "</FOBAmount>"
            glbfltTotalInvoice = fltTotalInvoice
            Invoice = Invoice & "<FOBCurrency>" & strMoeda & "</FOBCurrency>"

            'Invoice = Invoice & "<ChargeInd>" & "N" & "</ChargeInd>" & vbCrLf

            'Invoice = Invoice & StrDetalhe

            Invoice = Invoice & "</CommercialInvoice>"


        Else


            Invoice = "<CommercialInvoice>" & vbCrLf
            Invoice = Invoice & "<InvoiceNumber>" & Invoice_STR() & "</InvoiceNumber>" & vbCrLf

            If IsDBNull(ProcessoDT.Rows(0)("cd_tp_oper")) = True Or ProcessoDT.Rows(0)("cd_tp_oper").ToString() = "CSR" Then

                Invoice = Invoice & "<TermsofSaleCode>" & "CPT" & "</TermsofSaleCode>" & vbCrLf
                'Invoice = Invoice & "<TermsofSaleDesc>" & Incoterm("CPT") & "</TermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<TermsofSaleDesc>" & "CPT" & "</TermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<FinalTermsofSaleCode>" & "CPT" & "</FinalTermsofSaleCode>" & vbCrLf
                'Invoice = Invoice & "<FinalTermsofSaleDesc>" & Incoterm("CPT") & "</FinalTermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<FinalTermsofSaleDesc>" & "CPT" & "</FinalTermsofSaleDesc>" & vbCrLf

                Invoice = Invoice & "<TermsofPaymentCode>" & CStr(ltempDT.Rows(0)("cd_termo").ToString()) & "</TermsofPaymentCode>" & vbCrLf
                Invoice = Invoice & "<TermsofPaymentDescription>" + ltempDT.Rows(0)("termo").ToString() + "</TermsofPaymentDescription>"

            Else
                Invoice = Invoice & "<TermsofSaleCode>" + ProcessoDT.Rows(0)("cd_tp_oper").ToString() + "</TermsofSaleCode>" + vbCrLf
                'Invoice = Invoice & "<TermsofSaleDesc>" & Incoterm(ProcessoDT.Rows(0)("cd_tp_oper").toString()) & "</TermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<TermsofSaleDesc>" & ProcessoDT.Rows(0)("cd_tp_oper").ToString() & "</TermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<FinalTermsofSaleCode>" + ProcessoDT.Rows(0)("cd_tp_oper").ToString() + "</FinalTermsofSaleCode>" + vbCrLf
                'Invoice = Invoice & "<FinalTermsofSaleDesc>" & Incoterm(ProcessoDT.Rows(0)("cd_tp_oper").toString()) & "</FinalTermsofSaleDesc>" & vbCrLf
                Invoice = Invoice & "<FinalTermsofSaleDesc>" & ProcessoDT.Rows(0)("cd_tp_oper").ToString() & "</FinalTermsofSaleDesc>" & vbCrLf
                Dim Cd_Termo As String
                Cd_Termo = IIf(IsDBNull(ltempDT.Rows(0)("cd_termo").ToString()), "", CStr(ltempDT.Rows(0)("cd_termo").ToString()))
                Dim Termo As String
                Termo = IIf(IsDBNull(ltempDT.Rows(0)("termo").ToString()), "", CStr(ltempDT.Rows(0)("termo").ToString()))
                Invoice = Invoice & "<TermsofPaymentCode>" & Cd_Termo & "</TermsofPaymentCode>" & vbCrLf
                Invoice = Invoice & "<TermsofPaymentDescription>" + Termo + "</TermsofPaymentDescription>"

            End If

            If lCabecalho.Rows.Count > 0 Then
                Invoice = Invoice & "<InvoiceAmount>" & "valor_invoice" & "</InvoiceAmount>"
                Invoice = Invoice & "<CurrencyCode>" + ltempDT.Rows(0)("cd_Tp_moeda").ToString() + "</CurrencyCode>"
                Invoice = Invoice & "<CIDate>" & VB6.Format(VB.Left(lCabecalho.Rows(0)("Data").ToString(), 10), "yyyyMMdd") & "</CIDate>"

            End If



            StrDetalhe = ""
            fltTotalInvoice = 0
            intSeq = 1
            For Each lTempDR As DataRow In ltempDT.Rows
                strMoeda = UCase(lTempDR.Item("cd_Tp_moeda").ToString())
                fltTotalInvoice = fltTotalInvoice + (lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString())
                StrDetalhe = StrDetalhe & "<CIProductDetail action='Add'>"
                StrDetalhe = StrDetalhe & "<LineItemNo>" & CStr(intSeq) & "</LineItemNo>"
                StrDetalhe = StrDetalhe & "<ProductCode>" + lTempDR.Item("Gmid").ToString() + "</ProductCode>"
                StrDetalhe = StrDetalhe & "<BrandName><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></BrandName>"
                StrDetalhe = StrDetalhe & "<InvoiceDesc><![CDATA[" & Upper_Case(lTempDR.Item("brandname").ToString()) & "]]></InvoiceDesc>"
                StrDetalhe = StrDetalhe & "<BilledQuantity>" & Replace(CStr(VB6.Format(lTempDR.Item("quantidade").ToString(), "0.00")), ",", ".") & "</BilledQuantity>" & vbCrLf
                StrDetalhe = StrDetalhe & "<BilledQuantityUnit>" & Upper_Case(lTempDR.Item("tipo_unid").ToString()) & "</BilledQuantityUnit>"
                StrDetalhe = StrDetalhe & "<Price>" & Replace(CStr(VB6.Format(lTempDR.Item("preco_unit").ToString(), "0.00")), ",", ".") & "</Price>" & vbCrLf
                StrDetalhe = StrDetalhe & "<PriceCurrency>" & UCase(lTempDR.Item("cd_Tp_moeda").ToString()) & "</PriceCurrency>"
                StrDetalhe = StrDetalhe & "<Amount>" & Replace(CStr(VB6.Format(lTempDR.Item("preco_unit").ToString() * lTempDR.Item("quantidade").ToString(), "0.00")), ",", ".") & "</Amount>"
                StrDetalhe = StrDetalhe & "<AmountCurrency>" & UCase(lTempDR.Item("cd_Tp_moeda").ToString()) & "</AmountCurrency>"

                StrDetalhe = StrDetalhe & "</CIProductDetail>"

                intSeq = intSeq + 1

            Next

            If ProcessoDT.Rows(0)("vlr_frete").ToString().Length = 0 Then
                vlr_frete = 0
            Else
                vlr_frete = ProcessoDT.Rows(0)("vlr_frete").ToString()
            End If

            Invoice = Replace(Invoice, "valor_invoice", Replace(CStr(fltTotalInvoice), ",", "."))
            If vlr_frete < fltTotalInvoice Then
                fltTotalInvoice = fltTotalInvoice - vlr_frete
            End If
            Invoice = Invoice & "<FOBAmount>" & Replace(CStr(fltTotalInvoice), ",", ".") & "</FOBAmount>"
            glbfltTotalInvoice = fltTotalInvoice
            Invoice = Invoice & "<FOBCurrency>" & strMoeda & "</FOBCurrency>"

            Invoice = Invoice & "<ChargeInd>" & "N" & "</ChargeInd>" & vbCrLf


            Invoice = Invoice & StrDetalhe

            Invoice = Invoice & "</CommercialInvoice>"

        End If


    End Function

    Private Function CodesNames(ByRef strTipo As String) As String


        Dim strDados As String
        Dim strCode As String
        Dim ltempDT As New Data.DataTable

        strDados = ""
        strCode = ""
        Select Case UCase(strTipo)
            Case UCase("SalesPerson")
                StrSql = "spINTSmartVendedor_Sel '" & ProcessoDT.Rows(0)("processo").ToString() & "'"

                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    strDados = IIf(IsDBNull(ltempDT.Rows(0)("nome_usuario")) = True, "", ltempDT.Rows(0)("nome_usuario").ToString())
                End If

            Case UCase("CargoDescription")
                strDados = Upper_Case(Nature_Goods_Samples)
            Case UCase("DestinationInlandCarrier")
                'RsTemp = Nothing

                StrSql = "spINTSmartBuscaTransportadora_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"

                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    If IsDBNull(ltempDT.Rows(0)("nome_raz_soc")) = False Then
                        strDados = Upper_Case(ltempDT.Rows(0)("nome_raz_soc").ToString())
                        strCode = ltempDT.Rows(0)("Cd_Vendor").ToString()
                    End If
                End If
            Case UCase("TypSvc")
                'RsTemp = Nothing

                StrSql = "spINTSmartTypeOfService_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"

                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then

                    If IsDBNull(ltempDT.Rows(0)("CodesNamesType")) = False Then
                        strDados = Upper_Case(ltempDT.Rows(0)("CodesNamesType").ToString())
                        strCode = ltempDT.Rows(0)("CodesNamesCode").ToString()
                    End If
                End If

            Case UCase("SapTrnsprtPoint")

                StrSql = "spINTSmartBuscaSapTrnsprtPoint_Sel '" + ProcessoDT.Rows(0)("processo").ToString() + "'"

                ltempDT = sqlCnn.BuscaInformacoes(StrSql)
                If ltempDT.Rows.Count > 0 Then
                    If IsDBNull(ltempDT.Rows(0)("SapTrnsprtPoint")) = False And ltempDT.Rows(0)("SapTrnsprtPoint").ToString().Length > 0 Then
                        strDados = Upper_Case(ltempDT.Rows(0)("SapTrnsprtPoint").ToString())
                    End If
                End If
        End Select


        CodesNames = ""
        CodesNames = "<CodesNames>" & vbCrLf
        CodesNames = CodesNames & "<CodesNamesType>" & strTipo & "</CodesNamesType>"
        CodesNames = CodesNames & "<CodesNamesName>"
        CodesNames = CodesNames & "<![CDATA[" & (strDados) & "]]>"

        CodesNames = CodesNames & "</CodesNamesName>"
        CodesNames = CodesNames & "<CodesNamesCode>" & strCode & "</CodesNamesCode>"
        CodesNames = CodesNames & "</CodesNames>"

        CodesNames = Replace(CodesNames, Chr(160), " ")
        CodesNames = Replace(CodesNames, Chr(13), " ")
        CodesNames = Replace(CodesNames, Chr(10), " ")


    End Function

End Class




'DataCertificadoDeOrigem
'Task

'Private Function Data_DeadLine() As String

'    Data_DeadLine = "<Status>" & vbCrLf

'    If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) <> "EM" Then
'        Data_DeadLine = ""
'        Exit Function
'    End If

'    Select Case UCase(VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2))
'        Case "EM"
'            Data_DeadLine = Data_DeadLine & "<StatusType type='LatestDeliveryDate'/>" & vbCrLf
'        Case "EA"
'            Data_DeadLine = Data_DeadLine & "<StatusType type='LatestDeliveryDate'/>" & vbCrLf
'        Case "IM"
'            Data_DeadLine = Data_DeadLine & "<StatusType type='LatestDeliveryDate'/>" & vbCrLf
'        Case "IO"
'            Data_DeadLine = Data_DeadLine & "<StatusType type='LatestDeliveryDate'/>" & vbCrLf
'        Case "EO"
'            Data_DeadLine = Data_DeadLine & "<StatusType type='LatestDeliveryDate'/>" & vbCrLf

'    End Select

'    Dim dl_carga As String

'    If IsDBNull(ProcessoDT.Rows(0)("dl_carga").ToString()) = False Then
'        If StrType = "301" Then
'            dl_carga = ConvertTimeZone(ProcessoDT.Rows(0)("dl_carga").ToString().ToString, "Eastern Standard Time")
'        Else
'            dl_carga = ProcessoDT.Rows(0)("dl_carga").ToString().ToString
'        End If

'        Data_DeadLine = Data_DeadLine & "<StatusDate>" & VB6.Format(dl_carga, "yyyymmdd") & "</StatusDate>" & vbCrLf
'        If VB6.Format(ProcessoDT.Rows(0)("dl_carga").ToString(), "hhmm") = "0000" Then
'            Data_DeadLine = Data_DeadLine & "<StatusTime></StatusTime>" & vbCrLf
'        Else
'            Data_DeadLine = Data_DeadLine & "<StatusTime>" & VB6.Format(dl_carga, "hhmm") & "</StatusTime>" & vbCrLf
'        End If
'        Data_DeadLine = Data_DeadLine & "</Status>"
'    Else
'        Data_DeadLine = ""
'    End If

'    If VB.Left(ProcessoDT.Rows(0)("processo").ToString(), 2) = "EM" Then
'        If ProcessoDT.Rows(0)("Cd_tp_carga").ToString() = 3 Then
'            Data_DeadLine = ""
'        End If
'    End If
'End Function