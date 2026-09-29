SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixAtualizarStatusAvebacao_Aut]

as

Declare @Num_Proc varchar(16)
Declare @IDRetorno bigint
Declare @iditem	int
Declare @idenvio bigint

-- Atualizando data da averbaçao
Declare @DataAvebacao DAtetime

print 'Averbacao'
print getdate()

Declare cDesemb cursor for
(
	select 
		C.Num_Proc,I.Valor ,C.ID,I.ID_Item ,ID_Envio 
	from 
		ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) 
		Join ATL_INT.dbo.Emix_Retorno_Export C with(nolock) on C.ID=I.ID 
		Join E_Mix_Consulta E with(nolock)  on E.id=C.ID_Envio 
		Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = C.Num_Proc and ID_Task=15		
	Where
		E.id_consulta_tipo = '18' and I.Campo='dt_averbacao'
		and I.Read_Dt is null --and  Valor_ATL is Not null 
		and TP.Dt_Conclusao is null 
		and I.Valor <> ''
		
)	
option(hash join)
print 'fim Averbacao'
print getdate()

open cDesemb
	fetch next from cDesemb into @Num_proc,@DataAvebacao, @IDRetorno, @IDItem,@idenvio
declare @intI Int
set @intI = 1

While @@Fetch_Status=0
	Begin
		Update Tarefas_Processos set Dt_Conclusao=@DataAvebacao,Cd_Usuario = 'ATL' where Num_Proc=@Num_Proc and ID_Task=15
		
		--Esta no codigo o esquema de parar a rotina, qdo vier averbado
		--update dbo.E_MIX_XML set dt_retorno=GETDATE()  where id=@idenvio 
		
		update ATL_INT.dbo.Emix_Retorno_Export_Item set Read_Dt = GETDATE() where ID=@IDRetorno and id_item= @iditem 
		
		print @intI
		set @intI = @intI + 1
		
		fetch next from cDesemb into @Num_proc,@DataAvebacao, @IDRetorno, @IDItem,@idenvio
		
	End
	
Close cDesemb
deallocate cDesemb	

print 'fim de tudo'
print getdate()
	
GO
