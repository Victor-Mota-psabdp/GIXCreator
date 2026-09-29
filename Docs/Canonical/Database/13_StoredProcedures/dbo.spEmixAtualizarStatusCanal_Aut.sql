SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--30-05-2018 - alterado para o ATL_INT
--CAdu -criei esta [dbo].[spEmixAtualizarStatusCanal_ComDataDesembaraco_Aut_] 
--pra limpar o q ja tem dt de desembaaco incluida pelo usuario

CREATE Procedure [dbo].[spEmixAtualizarStatusCanal_Aut]

as
Declare @Num_Proc varchar(16)
Declare @Canal_Retorno Varchar(20)
Declare @Canal_Antigo Varchar(20)
Declare @IDRetorno bigint
Declare @iditem	int
Declare @idenvio bigint

print 'Update'
print getdate()
Update ATL_INT.dbo.Emix_Retorno_Item set Valor_ATL='Green' where Valor='Verde' and Valor_ATL is null

Update ATL_INT.dbo.Emix_Retorno_Item set Valor_ATL='Red' where Valor='Vermelho'and Valor_ATL is null

Update ATL_INT.dbo.Emix_Retorno_Item set Valor_ATL='Yellow' where Valor='Amarelo' and Valor_ATL is null

print 'fim' 
print getdate()

Declare cTemp Cursor for
(
select 
	C.Num_Proc,I.Valor_ATL,isnull(Canal_LIM,'') Canal ,C.ID,I.ID_Item ,ID_Envio 
from 
	ATL_INT.dbo.Emix_Retorno_Item I with(nolock)
	Join ATL_INT.dbo.Emix_Retorno C  with(nolock) on  C.ID=I.ID 
	Join E_Mix_Consulta E with(nolock) on  E.id=C.ID_Envio 
	Join LLP_Imp_Mar LLP with(nolock) on  LLP.Num_Proc_Lim = C.Num_Proc 
Where 
	id_consulta_tipo = '10' and Campo='nome'
	and Read_Dt is null and  Valor_ATL is Not null 

Union all

select 
	C.Num_Proc,I.Valor_ATL,isnull(Canal_LIA,'') Canal ,C.ID,I.ID_Item ,ID_Envio 
from 
	ATL_INT.dbo.Emix_Retorno_Item I with(nolock) 
	Join ATL_INT.dbo.Emix_Retorno C  with(nolock) on  C.ID=I.ID 
	Join E_Mix_Consulta E with(nolock) on  E.id=C.ID_Envio 
	Join LLP_Imp_aer LLP with(nolock) on  LLP.Num_Proc_Lia = C.Num_Proc 
Where 
	id_consulta_tipo = '10' and Campo='nome'
	and Read_Dt is null and  Valor_ATL is Not null 

Union all


select 
	C.Num_Proc,I.Valor_ATL,isnull(Canal_LIO,'') Canal, C.ID,I.ID_Item ,ID_Envio 
from 
	ATL_INT.dbo.Emix_Retorno_Item I with(nolock) 
	Join ATL_INT.dbo.Emix_Retorno C  with(nolock) on  C.ID=I.ID 
	Join E_Mix_Consulta E with(nolock) on  E.id=C.ID_Envio 
	Join LLP_Imp_OUT LLP with(nolock) on  LLP.Num_Proc_Lio = C.Num_Proc 
Where 
	id_consulta_tipo = '10' and Campo='nome'
	and Read_Dt is null and  Valor_ATL is Not null 
	)
	option(hash join)
	open cTemp
	fetch next from cTemp into @Num_proc,@Canal_Retorno, @Canal_Antigo, @IDRetorno, @IDItem,@idenvio

print 'Canal'
print getdate()

While @@Fetch_Status=0
	Begin
		--Idenferido
		If (@Canal_Antigo <> @Canal_Retorno)
			Begin
				--Atualizado status da Ordem
				if LEFT(@num_Proc,2)='IO'
					Begin
						Update LLP_Imp_Out set Canal_Lio=@Canal_Retorno where Num_Proc_Lio = @Num_Proc 
					End

				if LEFT(@num_Proc,2)='IM'
					Begin
						Update LLP_Imp_Mar set Canal_Lim=@Canal_Retorno where Num_Proc_Lim = @Num_Proc 
					End
					if LEFT(@num_Proc,2)='IA'
				Begin
					Update LLP_Imp_Aer set Canal_Lia=@Canal_Retorno where Num_Proc_Lia = @Num_Proc 
				End
		
			End
			
			update ATL_INT.dbo.Emix_Retorno_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
			
		fetch next from cTemp into @Num_proc,@Canal_Retorno, @Canal_Antigo, @IDRetorno, @IDItem,@idenvio
	End

Close cTemp
deallocate ctemp

-- Atualizando data de desembaraco
Declare @DataDesembaraco DAtetime

print 'Desemb'
print getdate()

Declare cDesemb cursor for
(
select 
	C.Num_Proc,I.Valor ,C.ID,I.ID_Item ,ID_Envio 
from 
	ATL_INT.dbo.Emix_Retorno_Item I with(nolock) 
	Join ATL_INT.dbo.Emix_Retorno C with(nolock)   on C.ID=I.ID 
	Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
	Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = C.Num_Proc and ID_Task=4 
	--left join Emix_Retorno_Item CA on CA.ID = I.ID and CA.Campo = 'nome'
Where 
	--C.Num_Proc = 'IMCSR201505037BR' and
	E.id_consulta_tipo = '10' and I.Campo='dt_desembaraco'
	--and CA.Valor = 'Verde'
	and I.Read_Dt is null --and  Valor_ATL is Not null 
	and TP.Dt_Conclusao is null 

)	
option(hash join)
print 'fim desemb'
print getdate()

open cDesemb
	fetch next from cDesemb into @Num_proc,@DataDesembaraco, @IDRetorno, @IDItem,@idenvio
declare @intI Int
set @intI = 1

While @@Fetch_Status=0
	Begin
		Update Tarefas_Processos set Dt_Conclusao=@DataDesembaraco,Cd_Usuario = 'ATL' where Num_Proc=@Num_Proc and ID_Task=4
		
		update dbo.E_MIX_XML set dt_retorno=GETDATE(), retorno_erro=NULL  where id=@idenvio 
		
		update ATL_INT.dbo.Emix_Retorno_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
		
		print @intI
		set @intI = @intI + 1
		
		fetch next from cDesemb into @Num_proc,@DataDesembaraco, @IDRetorno, @IDItem,@idenvio
		
	End
	
Close cDesemb
deallocate cDesemb	

print 'fim de tudo'
print getdate()
	
GO
