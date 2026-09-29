SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCamposAdicionais_InsUpd] --'IAMTH202003001BR', 'Valor CIF', '1893.700992'  
   
 @Num_Proc  VarChar(16),  
 @Descr_Campo varchar(30),  
 @Campo_Dados Varchar(500)  
  
AS  
  
BEGIN TRANSACTION  
  
 Declare @ID_Campo int  
 Declare @Cd_Pes_Grupo varchar(10)  
 set @Cd_Pes_Grupo = (select Cd_Pes_Grupo from grupo where grupo = right(left(@Num_Proc,5),3))  
 set @ID_Campo = (select ID_Campo from Tipo_Campo_Cliente where Descr_Campo=@Descr_Campo and (Cd_Pes_Grupo=@Cd_Pes_Grupo or cd_pes_grupo='10017'))  
  
 if exists(select Tipo from tipo_campo_cliente where tipo='F' and Id_Campo=@ID_Campo)  
  Begin  
   set @Campo_Dados = replace(@Campo_Dados,'.','')  
   set @Campo_Dados = replace(@Campo_Dados,',','.')  
  End  
  
 declare @Host varchar(20) --SYSNAME --  
 declare @session_id int  

 --Alessandra 23/03/2020 
 -- Não funciona no novo server, ver mais tarde se precisa mesmo e como recuperar a informação e passar via app
 --Ja estava desabilitado
 --select @Host = Client_Net_Address, @session_id = con.most_recent_session_id from sys.dm_exec_connections con     
 --INNER JOIN sys.dm_exec_sessions sess on con.session_id = sess.session_id     
 --where Sess.Session_ID = @@Spid  
  
 declare @cd_usuario varchar(20)  
 set @cd_usuario = (select top 1 cd_usuario from tmpLOG where job=@num_proc and host = @Host and session_id = @session_id)  
  
 if exists (select Campo_Dados from Campo_Processo where Id_Campo=@Id_Campo and Num_Proc=@Num_Proc)  
  if @Campo_Dados=''  
   BEGIN  
    DELETE  
     Campo_Processo  
    WHERE  
     Id_Campo=@Id_Campo and Num_Proc=@Num_Proc  
   END  
  Else  
   BEGIN  
    if NOT (@Num_Proc = 'IASWB201911011BR' and @Id_Campo = '31')
    BEGIN  
     UPDATE  
      Campo_Processo  
     SET  
      Campo_Dados = @Campo_Dados, Dt_Ins = Getdate(), cd_usuario = @cd_usuario  
     WHERE  
      Id_Campo=@Id_Campo and Num_Proc=@Num_Proc  
    END  
   END  
 ELSE  
  if @Id_Campo is NOT null or @Id_Campo <> ''  
   BEGIN  
    INSERT INTO  
     Campo_Processo  
     (  
      Num_Proc,  
      Id_Campo,   
      Campo_Dados,  
      Dt_Ins,  
      cd_usuario  
     )  
    VALUES  
     (  
      @Num_Proc,  
      @Id_Campo,  
      @Campo_Dados,  
      getdate(),  
      @cd_usuario  
     )  
   END  
  
IF @@Error <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RETURN -1  
 END  
  
  
COMMIT TRANSACTION  
  
  
  
  
  
  

GO
