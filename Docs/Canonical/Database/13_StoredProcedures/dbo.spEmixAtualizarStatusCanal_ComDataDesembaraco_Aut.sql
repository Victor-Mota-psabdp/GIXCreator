SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--30-05-2018 - ALTERADO PARA ATL_INT
CREATE Procedure [dbo].[spEmixAtualizarStatusCanal_ComDataDesembaraco_Aut]

as

Declare @idenvio bigint

Declare cDesembClosed cursor for
(
select 
	distinct  ID_Envio
from 
	ATL_INT.dbo.Emix_Retorno_Item I with(nolock) 
	Join ATL_INT.dbo.Emix_Retorno C  with(nolock)  on C.ID=I.ID 
	Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
	Join E_Mix_XML X with(nolock)  on E.id=X.id 
	Join Tarefas_Processos TP with(nolock)  on TP.Num_Proc = C.Num_Proc and ID_Task=4 
	--left join Emix_Retorno_Item CA on CA.ID = I.ID and CA.Campo = 'nome'
Where 
	E.id_consulta_tipo = '10' and I.Campo='dt_desembaraco'
	--and CA.Valor = 'Verde'
	and I.Read_Dt is null
	and TP.Dt_Conclusao is not null 
	and X.dt_retorno is null
)	
option (hash join)
open cDesembClosed	
	fetch next from cDesembClosed into @idenvio
declare @intJ Int
set @intJ = 1

While @@Fetch_Status=0
	Begin
		--Update Tarefas_Processos set Dt_Conclusao=@DataDesembaraco where Num_Proc=@Num_Proc and ID_Task=4
		
		update dbo.E_MIX_XML set dt_retorno=GETDATE(),Retorno_Erro = NULL  where id=@idenvio 
		
		--update Emix_Retorno_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
		
		print @intJ
		set @intJ = @intJ + 1
		
		--fetch next from cDesembClosed into @Num_proc,@DataDesembaraco, @IDRetorno, @IDItem,@idenvio
		fetch next from cDesembClosed into @idenvio
		
	End
	
Close cDesembClosed
deallocate cDesembClosed



--select 
--	distinct  ID_Envio
--from 
--	ATL_INT.dbo.Emix_Retorno_Item I with(nolock) 
--	Join ATL_INT.dbo.Emix_Retorno C  with(nolock)  on C.ID=I.ID 
--	Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
--	Join E_Mix_XML X with(nolock)  on E.id=X.id 
--	Join Tarefas_Processos TP with(nolock)  on TP.Num_Proc = C.Num_Proc and ID_Task=4 
--	left join Emix_Retorno_Item CA with(nolock)  on CA.ID = I.ID and CA.Campo = 'nome'
--Where 
--	E.id_consulta_tipo = '10' and I.Campo='dt_desembaraco'
--	and CA.Valor <> 'Verde'
--	and I.Read_Dt is null
--	and TP.Dt_Conclusao is not null 
--	and X.dt_retorno is null	
GO
