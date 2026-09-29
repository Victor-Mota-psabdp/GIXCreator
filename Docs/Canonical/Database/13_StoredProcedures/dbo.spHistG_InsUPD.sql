SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
  
--05-06-2008  
--Week 23  
--Alteração no tamanho do campo @Tp_Ocor VarChar(150)  - Claudio  
  
CREATE        Procedure [dbo].[spHistG_InsUPD]  
  
 @HSGProcesso VarChar(16),  
 @HSGSeq   int = Null,  
 @Shipper  VarChar(30),  
 @Tp_Ocor  VarChar(50),  
 @HSDDescricao VarChar(2000),  
 @HSGData  Datetime,  
 @HSGDataFU  Datetime,  
 @Usuario  VarChar(50),  
 @Disp_Cliente Char(1),  
 @Cd_Origem  Char(1),  
 @ID_NC   VarChar(150) --Recebe a Descricao do NC é gato, mas de raça hehee  
  
AS  
  
--BEGIN TRANSACTION  
  
  
 Declare @cd_pes  varchar(20)  
 set @cd_pes = (select cd_pes from pessoa With(nolock) where apelido = @Shipper)  
  
 Declare @cd_tp_ocor int  
 set @cd_tp_ocor = (select top 1 cd_tp_ocor from tipo_ocorrencia With(nolock) where Nome_Tp_Ocor = @tp_ocor)  
  
 Declare @Cd_Usuario varchar(6)  
  
  set @Cd_Usuario = (Select top 1 Cd_usuario from Usuario With(nolock) where nome_usuario = @usuario)  
  
 Declare @cd_pes_grupo varchar(10)  
 --Set @cd_pes_grupo = (select cd_pes_grupo from grupo With(nolock) where grupo = right(left(@HSGProcesso,5),3)) 
 
 set @cd_pes_grupo = (select Cd_Pes_Grupo 
 from vwClienteALLJOBS V with(nolock) 
 join Pessoa_LLP LLP (nolock)  
	on LLP.Cd_Pes = V.cd_cliente	
 where V.num_proc = @HSGProcesso)
   

  
 Declare @Cd_NC varchar(40)  
    
 if exists(select top 1  cd_NC from Tipo_NC_Cliente With(nolock) where Descricao_NC = @ID_NC and (Cd_Pes_Grupo = @Cd_Pes_Grupo or Cd_Pes_Grupo = '10017'))  
 Begin  
  Set @Cd_NC = (select top 1  cd_NC from Tipo_NC_Cliente With(nolock) where Descricao_NC = @ID_NC and (Cd_Pes_Grupo = @Cd_Pes_Grupo or Cd_Pes_Grupo = '10017'))  
 End  
 else  
 Begin  
  Set @Cd_NC = (select top 1  cd_NC from Tipo_NC_Cliente With(nolock) where cd_NC = @ID_NC and (Cd_Pes_Grupo = @Cd_Pes_Grupo or Cd_Pes_Grupo = '10017'))  
 End  
  
--Historicos de Sistema ou Integração  
 IF @Cd_Origem = 'S' or @Cd_Origem='I'  
  BEGIN  
   if @HSGSEQ IS NULL  
    BEGIN  
     Set @HSGSEQ =(select Isnull(max(hsgseq),0) from hist_geral_sistema where hsgprocesso=@hsgprocesso)+1  
     INSERT INTO  
      HIST_GERAL_SISTEMA  
      (  
       HSGProcesso,HSGSeq,Cd_Pes,  
       Cd_Tp_Ocor,HSDDescricao,HSGData,  
       HSGDataFU,Cd_Usuario,Disp_Cliente,Cd_Origem,  
       ID_NC  
      )  
      VALUES  
      (  
       @HSGProcesso,@HSGSeq,@Cd_Pes,  
       @Cd_Tp_Ocor,@HSDDescricao,getdate(),  
       @HSGDataFU,@Cd_Usuario,@Disp_Cliente,@Cd_Origem,  
       @Cd_NC  
      )  
    end  
   else  
    BEGIN  
     UPDATE  
      HIST_GERAL_SISTEMA  
     SET  
      Disp_Cliente=@Disp_Cliente  
     WHERE  
      hsgprocesso=@hsgprocesso and HSGSeq=@HSGSeq  
    END  
   END  
 --Demais Origens: Usuario, Automatico...  
 ELSE  
  BEGIN  
   if @HSGSEQ IS NULL  
    BEGIN  
     Set @HSGSEQ =(select Isnull(max(hsgseq),0) from hist_geral where hsgprocesso=@hsgprocesso)+1  
     INSERT INTO  
      HIST_GERAL  
      (  
       HSGProcesso,HSGSeq,Cd_Pes,  
       Cd_Tp_Ocor,HSDDescricao,HSGData,  
       HSGDataFU,Cd_Usuario,Disp_Cliente,Cd_Origem,  
       ID_NC  
      )  
      VALUES  
      (  
       @HSGProcesso,@HSGSeq,@Cd_Pes,  
       @Cd_Tp_Ocor,@HSDDescricao,getdate(),  
       @HSGDataFU,@Cd_Usuario,@Disp_Cliente,@Cd_Origem,  
       @Cd_NC  
      )  
    end  
   else  
    BEGIN  
     UPDATE  
      HIST_GERAL  
     SET  
      Disp_Cliente=@Disp_Cliente  
     WHERE  
      hsgprocesso=@hsgprocesso and HSGSeq=@HSGSeq  
    END  
   END  
---------------------------------------------------------------   
 IF @cd_tp_ocor = 58  
  Begin  
   If exists(select id_task from tarefas_processos where id_task='22' and Num_Proc=@HSGProcesso)  
    Update   
     tarefas_processos  
    Set  
     Dt_Previsao = @HSGDataFU,  
     Cd_Usuario = @Cd_Usuario  
    where  
     id_task='22' and Num_Proc=@HSGProcesso  
   Else  
    Insert Into  
     tarefas_processos ( Num_Proc,Id_Task, Dt_Conclusao, Dt_Previsao, Cd_Usuario)  
    Values  
     (@HSGProcesso,'22',Null ,@HSGDataFU, @Cd_Usuario)  
  End  
---------------------------------------------------------------  
--Reativar Job Cancelado  
 IF @cd_tp_ocor = 81  
  Begin  
   If exists(select hsgprocesso from hist_geral where cd_tp_ocor=28 and hsgprocesso=@HSGProcesso) --Cancelamento de Job  
    Update   
     hist_geral  
    Set  
     cd_tp_ocor = 47  
    where  
     cd_tp_ocor=28 and hsgprocesso=@HSGProcesso  
  End  
  
--LOG----------------------------------------------------------------------  
 --Alessandra 23/03/2020 - ja estava desabilitado  
 --declare @Host varchar(20) --SYSNAME --  
 --declare @session_id int  
 --select @Host = Client_Net_Address, @session_id = con.most_recent_session_id from sys.dm_exec_connections con     
 --INNER JOIN sys.dm_exec_sessions sess on con.session_id = sess.session_id     
 --where Sess.Session_ID = @@Spid  
  
 --if exists(select * from tmpLOG where job=@HSGProcesso and cd_usuario=@cd_usuario and host=@Host )  
 -- begin  
 --  update tmpLOG set session_id = @session_id where job=@HSGProcesso and cd_usuario=@cd_usuario and host=@Host  
 -- end  
 --else  
 -- begin  
 --  insert into tmpLOG(job,cd_usuario,host,session_id)  
 --  values (@HSGProcesso,@cd_usuario,@Host,@session_id)  
 -- end  
  
-- IF @@ERROR<>0  
--  BEGIN  
--   ROLLBACK TRANSACTION  
--   RETURN -1  
--  END  
--COMMIT TRANSACTION  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
GO
