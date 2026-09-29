SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido p so bsucar casos do tipo 11 - 11 Status LI, pq deu pau em um caso q salvou um 11 e um 12 junto -   
--select * from Emix_Retorno where ID = 4066668 - 04/05/2017 -cadu  
  
CREATE Procedure [dbo].[spEmixAtualizarStatusLI_Aut]  
  
as  
  
--11 Indeferida  
--3 Em Analise  
-- 5 deferida  
-- 9 Embarque Autorizado  
--8 Solicitação Cancelada  
  
--select * from Tipo_Status_LI  
  
Declare @ID BigInt  
Declare @Num_proc Varchar(16)  
Declare @LI Varchar(50)  
Declare @StatusRetorno Varchar(50)  
Declare @ID_Status int  
Declare @StatusAntigo Varchar(50)  
Declare @NumSLI Varchar(16)  
Declare @TExt Varchar(100)  
DEclare @data datetime  
Declare @IDEnvio bigint  
Declare @idItem int  
  
Declare @DataVencimento Datetime  
Declare @IDRetorno  bigint  
  
  
Declare @TEMP Table  
 (  
  ID BigInt,  
  Num_proc Varchar(16),  
  LI Varchar(50),  
  StatusRetorno Varchar(50),  
  ID_Status int,  
  StatusAntigo Varchar(50),  
  NumSLI Varchar(16),    
  IDEnvio bigint,  
  idItem int  
 )  
   
 BEGIN  
 --10000  
 insert into @TEMP  
  select H.ID,H.Num_Proc,E.valor [LI],I.Valor [StatusRetorno],ID_Status ,Status_LI_Descricao StatusAntigo,Num_Solicitacao,ID_Envio,ID_Item       
  --from  dbo.Emix_Retorno_Item I with(nolock)  
  --INNER HASH Join Emix_Retorno H with(nolock) on H.ID=I.ID  
   from  ATL_INT.DBO.Emix_Retorno_Item I with(nolock)  
  INNER HASH Join ATL_INT.DBO.Emix_Retorno H with(nolock) on H.ID=I.ID  

  INNER HASH Join E_Mix_Consulta E with(nolock) on E.id=ID_Envio   
  INNER HASH Join Solicitacao_LI S with(nolock) on Num_LI=E.valor  
  INNER HASH Join Tipo_Status_LI TS with(nolock) on TS.ID_Status_LI=S.ID_Status  -- and H.num_proc=S.Num_Proc   
  Where    
  Campo='nome' and Read_Dt is null   
         
  --and I.Valor ='Cancelado'  
  --and I.Valor <>'Vencida'  
  and Tipo_Consulta = 11  
    
  --and I.Insert_Dt >= '2017-04-24 12:00:00'  
  --Cadu -inclui o horario, pois os casos antes deste estavam dando problema por estar   
  --duplicando com uns casos de Exportaçao  
    
  and insert_dt > GETDATE() -7   
   
  order by H.ID  
  --OPTION(HASH JOIN)  
 END   
  
  
Declare cTemp Cursor for  
(  
 select ID ,Num_proc,LI ,StatusRetorno,ID_Status,  
  StatusAntigo,NumSLI [Num_Solicitacao],IDEnvio,idItem   
 from @Temp  
--select  top 100 H.ID,H.Num_Proc,E.valor [LI],I.Valor [StatusRetorno],ID_Status ,Status_LI_Descricao StatusAntigo,Num_Solicitacao,ID_Envio,ID_Item     from  dbo.Emix_Retorno_Item I with(nolock)  
--Join Emix_Retorno H with(nolock) on H.ID=I.ID   
--Join E_Mix_Consulta E with(nolock) on E.id=ID_Envio   
--Join Solicitacao_LI S with(nolock) on Num_LI=E.valor  
--Join Tipo_Status_LI TS with(nolock) on TS.ID_Status_LI=S.ID_Status  -- and H.num_proc=S.Num_Proc   
--Where Campo='nome' and Read_Dt is null and  
--E.dt_ins >= getdate() - 30 and insert_dt > GETDATE() - 7  
  
)  
  
open cTemp  
SEt @data = (select GETDATE())  
fetch next from cTemp into @ID,@Num_proc,@LI, @StatusRetorno, @ID_Status, @StatusAntigo, @NumSLI,@idEnvio,@iditem  
  
While @@Fetch_Status=0  
 Begin  
  --Idenferido  
  --print @ID_Status  
  --print @StatusRetorno  
    
  If (@StatusRetorno='Indeferido' and @ID_Status not in (11))    
   Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + @StatusRetorno   
    Update Solicitacao_LI Set ID_Status=11 where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','N','U',null   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
  If (@StatusRetorno='Indeferido' and @ID_Status  in (11))    
   Begin  
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
  
  If (@StatusRetorno='Deferido' and @ID_Status not in (5,8))    
   Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + @StatusRetorno   
    --Update Solicitacao_LI Set ID_Status=5 , Dt_Deferimento = convert(datetime,convert(varchar(10),GETDATE(),103),103) where Num_Solicitacao =@NumSLI   
    Update Solicitacao_LI Set ID_Status=5 , Dt_Deferimento = GETDATE() where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','S','U',null   
    --Update E_MIX_XML set Dt_Retorno=GETDATE() where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
  --Cadu 10/10/2016 - 'DEFERIDA RESERVADO'  
  If ((@StatusRetorno in ('Deferido','DEFERIDA RESERVADO')) and @ID_Status  in (5,8))    
   Begin     
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
   End  
     
      
  --Cadu  18/06/2015   
  If (@StatusRetorno='Autorização de Embarque' and @ID_Status not in (9))    
   Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + @StatusRetorno   
    --Update Solicitacao_LI Set ID_Status=5 , Dt_Deferimento = convert(datetime,convert(varchar(10),GETDATE(),103),103) where Num_Solicitacao =@NumSLI   
    Update Solicitacao_LI Set ID_Status=9 , Dt_Aut_Embarque = GETDATE() where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','S','U',null   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
  If (@StatusRetorno='Autorização de Embarque' and @ID_Status  in (9))    
   Begin  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
   End  
     
  If (@StatusRetorno='Em Exigência' and @ID_Status not in (4,8))    
   Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + @StatusRetorno   
    Update Solicitacao_LI Set ID_Status=4 where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','N','U',null   
    --Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio  --Estava encerrando qdo bem o status Em exigencia Cadu  05/01/2023  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
   If (@StatusRetorno='Em Exigência' and @ID_Status  in (4,8))    
   Begin  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
     
   If (@StatusRetorno in ('Para Análise','Em Análise') and @ID_Status  in (3,4,8))    
   Begin  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End     
     
  If (@StatusRetorno in ('Deferido Utilizado','Reservado') and @ID_Status not in (6,8))    
  Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + @StatusRetorno   
    --Update Solicitacao_LI Set ID_Status=6 ,Dt_Deferimento = convert(datetime,convert(varchar(10),GETDATE(),103),103) where Num_Solicitacao =@NumSLI   
    Update Solicitacao_LI Set ID_Status=6 ,Dt_Deferimento =GETDATE() where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','S','U',null   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
  If (@StatusRetorno in ('Deferido Utilizado','Reservado') and @ID_Status  in (6,8))    
   Begin  
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
    
  --Cadu  10/10/2016 inclui o 11 - indeferida  
  If (@StatusRetorno in ('Para Análise','Em Análise') and @ID_Status  in (9,6,5,11))    
   Begin  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem  
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
   End  
    
  if (@ID_Status=12 or (@StatusRetorno='Vencida' and @ID_Status  in (3,4)))  
   Begin  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem  
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio    
   End  
     
  --cadu    
  If (@StatusRetorno='Desembaraçada' and @ID_Status not in (5,6,8))    
   Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + 'Deferida e Utilzada'  
    --Update Solicitacao_LI Set ID_Status=5 , Dt_Deferimento = convert(datetime,convert(varchar(10),GETDATE(),103),103) where Num_Solicitacao =@NumSLI   
    Update Solicitacao_LI Set ID_Status=6 , Dt_Deferimento = GETDATE() where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','S','U',null   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
    
  If (@StatusRetorno='Desembaraçada' and @ID_Status  in (5,6))    
   Begin  
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
   End  
     
  --cadu 29-1-2016  
  If (@StatusRetorno='Cancelado' and @ID_Status not in (8))    
   Begin  
    Set @TExt = 'Mudança de Status da LI:' + @LI + '-' + 'DE:' + @StatusAntigo + ' - PARA:' + @StatusRetorno   
    Update Solicitacao_LI Set ID_Status=8 where Num_Solicitacao =@NumSLI   
    --print @NumSLI  
    exec dbo.[spHistG_InsUPD] @NumSLI,Null ,Null,'LI - Ocorrencias',@TExt ,@data,null ,'ATL System','N','U',null   
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
  If (@StatusRetorno='Cancelado' and @ID_Status  in (8))    
   Begin  
    Update E_MIX_XML set Dt_Retorno=GETDATE(), retorno_erro=NULL where id=@IDEnvio   
    Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
   End  
     
  --if (@StatusRetorno ='Desembaraçada')  
  -- Begin  
  --  Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt=GETDATE() where ID=@ID and  ID_Item=@iditem   
  -- End  
    
  fetch next from cTemp into @ID,@Num_proc,@LI, @StatusRetorno, @ID_Status, @StatusAntigo, @NumSLI,@idenvio,@iditem  
 End  
  
Close cTemp  
deallocate ctemp  
  
  
  
-- Atualizando data de vencimento  
  
  
Declare cDesemb cursor for  
(  
select   
 C.Num_Proc,I.Valor ,C.ID,I.ID_Item ,ID_Envio,Num_Solicitacao,E.Valor [LI]  
   
from   
 ATL_INT.DBO.Emix_Retorno_Item I with(nolock)   
 Join ATL_INT.DBO.Emix_Retorno C with(nolock)   on C.ID=I.ID   
 Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio   
 Join Solicitacao_LI S with(nolock) on Num_LI=E.valor  
Where   
 --C.Num_Proc = 'IMSLA201509032BR' and  
 E.id_consulta_tipo = '11' and I.Campo='dt_validade'   
 and I.Read_Dt is null    
 and S.Dt_Vencimento is null   
 and I.valor is not null  
)  
option (hash join)  
  
open cDesemb  
 fetch next from cDesemb into @Num_proc,@DataVencimento, @IDRetorno, @IDItem,@idenvio,@NumSLI, @LI  
declare @intI Int  
set @intI = 1  
  
While @@Fetch_Status=0  
 Begin  
  Update Solicitacao_LI Set Dt_Vencimento = @DataVencimento where   
   Num_Solicitacao =@NumSLI  and Num_LI = @LI and Num_Proc =@Num_proc   
    
  update dbo.E_MIX_XML set dt_retorno=GETDATE(), retorno_erro=NULL where id=@idenvio   
    
  Update ATL_INT.DBO.Emix_Retorno_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem   
   
  fetch next from cDesemb into @Num_proc,@DataVencimento, @IDRetorno, @IDItem,@idenvio,@NumSLI,@LI  
    
 End  
   
Close cDesemb  
deallocate cDesemb   
  
  
GO
