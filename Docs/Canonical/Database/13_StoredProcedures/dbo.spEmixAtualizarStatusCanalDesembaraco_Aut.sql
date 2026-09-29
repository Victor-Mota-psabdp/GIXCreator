SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--1º Altera o canal, utilizando o que vem na dde
-- a luciana so informou o status que eh canal verde = LIBERADO S/CONF.ADUANEIRA
--2º inclui a data de desembaraco pelos dados da DDE = data de LIBERADO S/CONF.ADUANEIRA
--estou salvando com o nome de dt_efetivado

--3º SELECAO PARA EXAME DOCUMENTAL  - Amarelo
--incluir o canal amarelo

--4º SELECAO PARA EXAME DOCUMENTAL e Ver. Fis.  - Vermelho
--incluir o canal vermelho

--5º - Inicio de Transito
-- incluir o task: Inicio de Transito - 195

--6º - Transito Concluido
--incluir o task: Transito Concluido


CREATE Procedure [dbo].[spEmixAtualizarStatusCanalDesembaraco_Aut]

as

Declare @Num_Proc varchar(16)
Declare @Canal_Retorno Varchar(20)
Declare @Canal_Antigo Varchar(20)
Declare @IDRetorno bigint
Declare @iditem	int
Declare @idenvio bigint
Declare @Task	int

print 'Update'
print getdate()

--select * from Emix_Retorno_Export_Item where Valor like 'selecao%EXAME%'
Update ATL_INT.dbo.Emix_Retorno_Export_Item set Valor_ATL='Green' where Valor='LIBERADO S/CONF.ADUANEIRA' and Valor_ATL is null

----select * from Emix_Retorno_Export_Item I  where Valor='LIBERADO S/CONF.ADUANEIRA' and Valor_ATL is null
----and ID <> 3669307
--select Num_Proc,* from Emix_Retorno_Export_Item I 
--	join Emix_Retorno_Export E on E.ID = I.ID
--where 
--	Valor='LIBERADO S/CONF.ADUANEIRA' and Valor_ATL is null
	
--select * from Emix_Retorno_Export_Item where Valor='SELECAO PARA EXAME DOC. E VER.FIS.'and Valor_ATL is null
Update ATL_INT.dbo.Emix_Retorno_Export_Item set Valor_ATL='Red' where Valor='SELECAO PARA EXAME DOC. E VER.FIS.' and Valor_ATL is null

--select * from Emix_Retorno_Export_Item where Valor='SELECAO PARA EXAME DOCUMENTAL' and Valor_ATL is null
Update ATL_INT.dbo.Emix_Retorno_Export_Item set Valor_ATL='Yellow' where Valor='SELECAO PARA EXAME DOCUMENTAL' and Valor_ATL is null

print 'fim' 
print getdate()

	Declare cTemp Cursor for
	(
		select 
			C.Num_Proc,I.Valor_ATL,isnull(Canal_Lem,'') Canal ,C.ID,I.ID_Item ,ID_Envio 
		from 
			ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock)
			Join ATL_INT.dbo.Emix_Retorno_Export C  with(nolock) on  C.ID=I.ID 
			Join E_Mix_Consulta E with(nolock) on  E.id=C.ID_Envio 
			Join LLP_Exp_Mar LLP with(nolock) on  LLP.Num_Proc_Lem = C.Num_Proc 
		Where 
			id_consulta_tipo = '20' and Campo='nome'
			and Read_Dt is null and  Valor_ATL is Not null 
			and insert_dt > GETDATE() -2


		Union all

		select 
			C.Num_Proc,I.Valor_ATL,isnull(Canal_Lea,'') Canal ,C.ID,I.ID_Item ,ID_Envio 
		from 
			ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) 
			Join ATL_INT.dbo.Emix_Retorno_Export C  with(nolock) on  C.ID=I.ID 
			Join E_Mix_Consulta E with(nolock) on  E.id=C.ID_Envio 
			Join LLP_Exp_Aer LLP with(nolock) on  LLP.Num_Proc_Lea = C.Num_Proc 
		Where 
			id_consulta_tipo = '20' and Campo='nome' 
			and Read_Dt is null and  Valor_ATL is Not null 
			and insert_dt > GETDATE() -2

		Union all


		select 
			C.Num_Proc,I.Valor_ATL,isnull(Canal_Leo,'') Canal, C.ID,I.ID_Item ,ID_Envio 
		from 
			ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) 
			Join ATL_INT.dbo.Emix_Retorno_Export C  with(nolock) on  C.ID=I.ID 
			Join E_Mix_Consulta E with(nolock) on  E.id=C.ID_Envio 
			Join LLP_exp_OUT LLP with(nolock) on  LLP.Num_Proc_Leo = C.Num_Proc 
		Where 
			id_consulta_tipo = '20' and Campo='nome'
			and Read_Dt is null and  Valor_ATL is Not null
			and insert_dt > GETDATE() -2 
	)
	
	option (hash join)
	
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
				if LEFT(@num_Proc,2)='EO'
					Begin
						Update LLP_Exp_Out set Canal_Leo=@Canal_Retorno where Num_Proc_Leo = @Num_Proc 
					End

				if LEFT(@num_Proc,2)='EM'
					Begin
						Update LLP_Exp_Mar set Canal_Lem=@Canal_Retorno where Num_Proc_Lem = @Num_Proc 
					End
					if LEFT(@num_Proc,2)='EA'
				Begin
					Update LLP_exp_Aer set Canal_Lea=@Canal_Retorno where Num_Proc_Lea = @Num_Proc 
				End
		
			End
			
			update ATL_INT.dbo.Emix_Retorno_Export_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
			
		fetch next from cTemp into @Num_proc,@Canal_Retorno, @Canal_Antigo, @IDRetorno, @IDItem,@idenvio
	End

Close cTemp
deallocate ctemp

-- Atualizando data da desembaraco
Declare @DataDesembaraco DAtetime

print 'Desemb'
print getdate()

Declare cDesemb cursor for
(
	select 
		C.Num_Proc,I.Valor ,C.ID,I.ID_Item ,ID_Envio
		--,TP.Dt_Conclusao 
	from 
		ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) 
		Join ATL_INT.dbo.Emix_Retorno_Export C with(nolock)   on C.ID=I.ID 
		Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
		Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = C.Num_Proc and ID_Task=4		
	Where
		E.id_consulta_tipo = '20' and I.Campo='dt_efetivado'
		and I.Read_Dt is null 
		and TP.Dt_Conclusao is null 
		and insert_dt > GETDATE() -2 
	
)

option (hash join)	

print 'fim desemb'
print getdate()

open cDesemb
	fetch next from cDesemb into @Num_proc,@DataDesembaraco, @IDRetorno, @IDItem,@idenvio
declare @intI Int
set @intI = 1

While @@Fetch_Status=0
	Begin
		Update Tarefas_Processos set Dt_Conclusao=@DataDesembaraco,Cd_Usuario = 'ATL' where Num_Proc=@Num_Proc and ID_Task=4
		
		--update dbo.E_MIX_XML set dt_retorno=GETDATE()  where id=@idenvio 
		
		update ATL_INT.dbo.Emix_Retorno_Export_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
		
		print @intI
		set @intI = @intI + 1
		
		fetch next from cDesemb into @Num_proc,@DataDesembaraco, @IDRetorno, @IDItem,@idenvio
		
	End
	
Close cDesemb
deallocate cDesemb	

--Campos novos que a luciana pediu
-- Atualizando data da desembaraco
Declare @DataTask DAtetime

print 'Task'
print getdate()

Declare cTask cursor for
(
	select 
		C.Num_Proc,I.Valor ,C.ID,I.ID_Item ,ID_Envio,195
		--,TP.Dt_Conclusao 
	from 
		ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) 
		Join ATL_INT.dbo.Emix_Retorno_Export C with(nolock)   on C.ID=I.ID 
		Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
		Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = C.Num_Proc and ID_Task=195		
	Where
		E.id_consulta_tipo = '20' and I.Campo='dt_inicioTransito'
		and I.Read_Dt is null 
		and TP.Dt_Conclusao is null 
		and insert_dt > GETDATE() -2 
		
	UNION ALL
	
	select 
		C.Num_Proc,I.Valor ,C.ID,I.ID_Item ,ID_Envio,196
		--,TP.Dt_Conclusao 
	from 
		ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) 
		Join ATL_INT.dbo.Emix_Retorno_Export C with(nolock)   on C.ID=I.ID 
		Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
		Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = C.Num_Proc and ID_Task=196
	Where
		E.id_consulta_tipo = '20' and I.Campo='dt_transitoConcluido'
		and I.Read_Dt is null 
		and TP.Dt_Conclusao is null 
		and insert_dt > GETDATE() -2
	
)	
option (hash join)

print 'fim Task'
print getdate()

open cTask
	fetch next from cTask into @Num_proc,@DataTask, @IDRetorno, @IDItem,@idenvio,@Task
declare @intK Int
set @intK = 1

While @@Fetch_Status=0
	Begin
		Update Tarefas_Processos set Dt_Conclusao=@DataTask,Cd_Usuario = 'ATL' where Num_Proc=@Num_Proc and ID_Task=@Task
		
		update ATL_INT.dbo.Emix_Retorno_Export_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
		
		print @intK
		set @intK = @intK + 1
		
		fetch next from cTask into @Num_proc,@DataTask, @IDRetorno, @IDItem,@idenvio,@Task
		
	End
	
Close cTask
deallocate cTask	
	
GO
