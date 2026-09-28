Imports System
Imports System.Collections.Generic
Imports System.Text
Imports System.Data.SqlClient
Imports System.Data
Imports System.IO
Public Class cConexao

    Public Structure Credenciais

        Dim Servidor As String
        Dim DB As String
        Dim CaminhoDocs As String
        Dim CaminhoDocs2 As String
        Dim SQLUser As String
        Dim SQLPassword As String

    End Structure

    Public CredSQLInf As Credenciais
    Public cnn As SqlConnection
    Dim Sucess As Boolean
    Public arqINI As String
    Dim SQLUser As String
    Dim SQLPassword As String

    Public Sub Conectar()
        Try
            If arqINI.ToString() <> "" Then
                CarregaINI()
            End If

            If CredSQLInf.Servidor.Contains("WUSPBDPSQL04") Or CredSQLInf.Servidor.Contains("WUSPBDPSQL4") Then
                CredSQLInf.SQLUser = "ATLPROD"
                CredSQLInf.SQLPassword = "AtlProd@123"
                'CredSQLInf.Servidor = "WUSPBDPNODE04\WUSPBDPSQL04"
            ElseIf CredSQLInf.Servidor.Contains("172.21.61.141") Or CredSQLInf.Servidor.Contains("WUSPQASQL08") Or CredSQLInf.Servidor.Contains("WUSTSQL02") Then
                CredSQLInf.SQLUser = "ATLTEST"
                CredSQLInf.SQLPassword = "ATLT3st_SQL08"
                'CredSQLInf.Servidor = "WUSPBDPNODE04\WUSPBDPSQL04"
            ElseIf CredSQLInf.Servidor.Contains("192.168.54.226") Then
                CredSQLInf.SQLUser = "sa"
                CredSQLInf.SQLPassword = "cdssquidrestart"
            Else
                CredSQLInf.SQLUser = "ATLPROD"
                CredSQLInf.SQLPassword = "AtlProd@123"
            End If


            cnn = New SqlConnection("Data Source=" + CredSQLInf.Servidor + ";Connection Timeout=0; Initial Catalog=" + CredSQLInf.DB + " ;user id=" + CredSQLInf.SQLUser + ";password=" + CredSQLInf.SQLPassword + "")
            cnn.Open()
            Sucess = True

        Catch ex As Exception
            Sucess = False

        End Try
    End Sub
    Public Sub Desconectar()

        cnn.Close()
    End Sub



    Public Function BuscaInformacoes(ByVal strSQL As String) As DataTable

        Conectar()

        Dim daTemp As SqlDataAdapter
        Dim dtbTemp As DataTable
        Dim sqlCMD As SqlCommand

        daTemp = New SqlDataAdapter()
        dtbTemp = New DataTable()
        sqlCMD = New SqlCommand(strSQL, cnn)

        sqlCMD.CommandTimeout = 0
        daTemp.SelectCommand = sqlCMD
        daTemp.Fill(dtbTemp)

        Desconectar()

        Return dtbTemp
    End Function

    Public Sub ExecutaComando(ByVal StrSQL As String)

        Conectar()
        Dim CMD As SqlCommand = New SqlCommand()
        CMD.Connection = cnn
        CMD.CommandText = StrSQL
        CMD.ExecuteNonQuery()
        Desconectar()
    End Sub


    Public Sub CarregaINI()

        '1ª Linha do TXT = IP do Servidor onde está a base de dados
        '2ª Linha do TXT = Nome da Base de dados
        '3ª Linha do TXT = caminho onde estarão os docs
        '4ª Linha do TXT = Usuario do banco de dados

        Try

            If (arqINI.Substring(arqINI.Length - 4).ToString().ToUpper() <> ".INI") Then

                arqINI = arqINI + ".ini"
            End If

            Using sr As StreamReader = New StreamReader(Environment.CurrentDirectory.ToString() + "\\" + arqINI)

                CredSQLInf.Servidor = sr.ReadLine()
                CredSQLInf.DB = sr.ReadLine()
                CredSQLInf.CaminhoDocs = sr.ReadLine()
                CredSQLInf.CaminhoDocs2 = sr.ReadLine()
                CredSQLInf.SQLUser = sr.ReadLine()
            End Using


        Catch ex As Exception


        End Try


    End Sub

End Class
