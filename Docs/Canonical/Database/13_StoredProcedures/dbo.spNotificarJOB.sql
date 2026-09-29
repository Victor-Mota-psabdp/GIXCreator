SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--spNotificarJOB 'IACSR201103005BR','Claudio Alves dos Santos'

CREATE procedure [dbo].[spNotificarJOB] --'%','%'
(
	@JOB varchar(16),
	@Usuario varchar(50)
)
--Retornar no select no minimo 5 linhas (qtd de linha do mnuNotificar
AS
	Declare @Mensagem varchar(200)
	set @Mensagem = ''

---- Aviso Geral com data para expirar
--	IF getdate() < '2011-11-16 17:00'
--		Begin
--			set @Mensagem = 'Tip: Utilize as teclas de atalho para acessar mais rapidamente as Telas de JOB.'
--		End
 /*Comentado para verificar performace do ATL - ERbson 23-07-2013
	Declare @Idioma char(3)
	set @Idioma = (select top 1 cd_idioma from usuario With(nolock) where nome_usuario = @Usuario and ck_ativo = 1)

	Declare @Cd_Pes varchar(20)

	IF left(@JOB,1) = 'E'
		Begin
			set @Cd_Pes = (
							select top 1 cd_export_hea from house_exp_aer with(nolock) where num_proc_hea = @JOB
							UNION ALL
							select top 1 cd_export_hem from house_exp_mar with(nolock) where num_proc_hem = @JOB
							UNION ALL
							select top 1 cd_export_heo from house_exp_out with(nolock)  where num_proc_heo = @JOB
							)
		End
	ELSE
		Begin
			set @Cd_Pes = (
							select top 1 cd_consig_hia from house_imp_aer with(nolock)  where num_proc_hia = @JOB
							UNION ALL
							select top 1 cd_consig_him from house_imp_mar with(nolock)  where num_proc_him = @JOB
							UNION ALL
							select top 1 cd_consig_hio from house_imp_out with(nolock)  where num_proc_hio = @JOB
							)
		End

-- Verifica o Crédito para essa pessoa
		select descr_campo + ' - ' + 
			(case 
				when @Idioma = 'PTG' then M.Msg_Portugues
				when @Idioma = 'ING' then M.Msg_Ingles
				when @Idioma = 'ESP' then M.Msg_Espanhol
			end) Mensagem
		from 
			campo_pessoa C with(nolock)
			join tipo_campo_pessoa  T with(nolock) on T.id_campo = C.id_campo
			join mensagem_erro M with(nolock) on M.cod_erro = 88
		where 
			C.id_campo=1 and cd_pes=@Cd_Pes and campo_dados=2

--Avisa que tem Desembaraçado
--	UNION ALL
--		select 
--			'Processo Desembaraçado em ' + convert(char(10), dt_conclusao,103)  from tarefas_processos 
--		where 
--			num_proc = @JOB and id_task=5 and dt_conclusao is NOT null

---- Aviso para um usuario especifico
	--UNION ALL
	--	select 'Sr. Rafa não pedale o T.I. ' from usuario where nome_usuario = @Usuario and cd_usuario = 'RMO'

--	UNION ALL
--select 'Devido a manutenção de Emergencia, o ATL será desativado em 5 minutos e ficará off-line durante 10 minutos'

	UNION ALL
*/
		select @Mensagem Mensagem
--
	UNION ALL
		select ''
--
	UNION ALL
		select ''
--
	UNION ALL
		select ''
--
	UNION ALL
		select ''








GO
