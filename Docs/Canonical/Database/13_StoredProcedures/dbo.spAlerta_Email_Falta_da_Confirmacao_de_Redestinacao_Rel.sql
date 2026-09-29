SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel '10017',0,10
--select * from Tipo_Tarefas where  ID_Task in (42,200)
--42	Redestinação de Container
--200	Confirmação da Redestinação

--220	Confirmação da Redestinação

--Declare @cd_pes_grupo as Varchar(6)
--Declare	@dia as int
--Declare	@diafim as int

--set @cd_pes_grupo = '10017'
--set @dia = 1
--set @diafim = 5

CREATE procedure [dbo].[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel]
(
	@cd_pes_grupo as Varchar(6),
	@dia as int,
	@diafim as int
)

AS

Select
	HOU.Num_Proc_HIM										[JOB],	
	''														[Doc_Anexos],
	''														[Doc_Anexos_Nao_Obrigatorios],
	'Falta de Confirmação de Redestinação - JOB.:' + HOU.Num_Proc_HIM 
	+ ' - Redestinação : ' + isnull(convert(varchar(20),T42.Dt_Conclusao,103),'') 	[Assunto],
	NULL													[Doc_Anexos_Master],
	NULL													[CopyBDP],
	NULL													[JuntaPDF],
	convert(bit,0)											[Email_do_CompanyRegister],
	CLI.Apelido												[Company_Register],
	'********** References ****************' + '|' +
	'JOB.:' + HOU.Num_Proc_HIM + '|' +	
	'Grupo: ' + isnull(PP.Apelido,'') + '|' +
	'Consignatario: ' + isnull(CLI.Apelido	,'') + '|' +
	'Navio: ' + isnull(HOU.Navio_HIM,'') + '|' +
	'ETD: ' + isnull(convert(varchar(20),LLP.ETD_Lim,103),'') + '|' +
	'ATD: ' + isnull(convert(varchar(20),LLP.ATD_lim,103),'') + '|' +
	'ETA: ' + isnull(convert(varchar(20),LLP.ETA_Lim,103),'') + '|' +
	'ATA: ' + isnull(convert(varchar(20),LLP.ATA_Lim,103),'') + '|' +
	'HBL: ' + isnull(HOU.HAWB_HIM,'') + '|' +
	'MBL: ' + isnull(HOU.MAWB_HIM,'') + '|' +
	'Tipo da Carga: ' + isnull(TC.Nome_Tp_Carga,'') + '|' +
	'Origem: ' + isnull(ORG.Nome_Local,'') + '|' +
	'Destino: ' + isnull(DST.Nome_Local	,'') + '|' +	
	'PDF - DOC Embarque no JOB: ' + isnull(Case when DC20.Id_DC='20' then 'SIM' else 'NÂO' End	,'') + '|' +
	'PDF - BL Original no JOB: ' + isnull(Case when DC44.Id_DC='44' then 'SIM' else 'NÂO' End,'') + '|' +
	'BDP Produto: ' + isnull(B.Nome_BDP_Produto	,'') + '|' +
	'Status: ' + isnull(S.Status_Descricao	,'') + '|' +	
	'*************************************'  + '|' +
	'by BDP System' 				[MSG],
	
	NULL							[Previsao],
	NULL							[CD_Pes_Grupo],
	''								[Nome_Tp_Ocor],
	NULL							[ID],
	''								[Nome_Task],
	--NULL							[ResponderPara],
	''								[Emails],
	NULL							[Mensagem_Referencia_cliente],
	''								[Cliente],
	convert(bit,0)					Email_do_Agente_Consolidado,
	''								[Company_Register_Master],
	NULL							[Cliente_Master],
	NULL							[Master_JOB],
	NULL							StandardForms,
	''								[CorpoMSG],
	''								[CorpoMSGConsolidado],
	''								[Assunto_CorpoMSG],		
	''								[CorpoMSG_Doc_Anexos],		
	''								[Assunto_CorpoMSG_Doc_Anexos],
	
	U.Nome_Usuario					[Usuario],
	U.Email							[ResponderPara],
	convert(date,GETDATE())				DATA_HOJE,
	convert(date,T42.Dt_Conclusao)		DATA_Redestinacao,
	convert(date,(GETDATE() - @Dia))	DATA_Inicio,
	convert(date,(GETDATE() - @diafim)) DATA_fim,
	Org.Pais_Local
from House_Imp_Mar				HOU		with(nolock)
	JOIN LLP_Imp_Mar			LLP		with(nolock)	on LLP.Num_Proc_Lim		= HOU.Num_Proc_HIM
	JOIN Localidade				ORG		With (Nolock)	on ORG.Cd_Local			= HOU.Cd_Org_HIM
	JOIN Localidade				DST		with (Nolock)	on DST.Cd_Local			= HOU.Cd_Dst_HIM
	JOIN Tipo_Carga				TC		with(nolock)	on TC.Cd_Tp_Carga		= LLP.Cd_Tp_Carga	
	JOIN Job_Imp_Mar			JOB		with(nolock)	on JOB.Num_Proc_HIM		= HOU.Num_Proc_HIM
	JOIN Usuario				U		with(nolock)	on U.Cd_Usuario			= JOB.cd_usuario
	
	JOIN Pessoa					CLI		with(nolock)	on HOU.cd_consig_him	= CLI.cd_pes
	left Join Pessoa_LLP		PLLP	with(nolock)	on HOU.Cd_Consig_HIM	= PLLP.cd_pes
	left Join Pessoa			PP		with(nolock)	on PP.Cd_Pes			= cd_pes_grupo		
	
	join Campo_Processo			CP		with(nolock)	on CP.Num_Proc			= HOU.Num_proc_him and CP.Id_Campo = 143
	join BDP_Produto			B		with(nolock)	on B.ID_PD				= CP.Campo_Dados
	join Tarefas_Processos		T42		with (nolock)	on T42.Num_Proc			= HOU.Num_Proc_Him and T42.ID_Task = 42
	
	
	
	left join Tarefas_Processos T225	with (nolock)	on T225.Num_Proc		= HOU.Num_Proc_Him and T225.ID_Task = 225	
	left join Tipo_Status_Processo S	with (nolock)	on S.ID_Status			= LLP.ID_Status
	Left Join Doc_Anexos		DC20	with(nolock)	on HOU.Num_Proc_HIM		= DC20.Num_Proc and DC20.Id_DC = '20'
	Left Join Doc_Anexos		DC44	with(nolock)	on HOU.Num_Proc_HIM		= DC44.Num_Proc and DC44.Id_DC = '44'
	Left Join Doc_Anexos		DC29	with(nolock)	on HOU.Num_Proc_HIM		= DC29.Num_Proc and DC29.Id_DC = '29'	
Where
	T42.Dt_Conclusao is not null
	and T225.Dt_Conclusao is null
	and (PLLP.cd_pes_grupo = @cd_pes_grupo or @cd_pes_grupo = '10017')
	and LLP.Cd_Tp_Carga = 1 and	
	CP.Campo_Dados in (1,3) and	
	HOU.Cd_Dst_HIM = 'SSZ' and
	Convert(datetime,HOU.Dt_Emis_HIM,103) > '2017-01-01' and 
	(Isnull(LLP.ID_Status,1) not in (9,8,5))	
	and 	
		convert(date,T42.Dt_Conclusao) 
		between convert(date,GETDATE()- @diafim)  and convert(date,GETDATE()- (@dia))
		

----select * from [dbo].[Tipo_Alerta_Redestinacao]

----select * from [dbo].[Alerta_Email_Redestinacao]

----Falta da Confirmação da Redestinação
----spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel
----Alertas Falta da Confirmação da Redestinação - CSR / Supervisor / Coordenador / Gerente / Diretoria:
----1º Alerta - Enviar alerta ao CSR após 1 dia do preenchimento do Task - Redestinação e o não preenchimento do Task - 
----Confirmação da Redestinação; 
----2º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente após 2 dia 
----do preenchimento do Task - Redestinação e o não preenchimento do Task - Confirmação da Redestinação; 
----3º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente/Diretoria após 3 dia 
----do preenchimento do Task - Redestinação e o não preenchimento do Task - Confirmação da Redestinação; 
----[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel]'P21128',1
----[spRedestinacao_Rel]''
----select * from Pessoa where Apelido = 'GRUPO OXITENO'

--ALTER procedure [dbo].[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel]
--(
--	@cd_pes_grupo as Varchar(6),
--	@dias as int
--)

--AS

--Select
--	HOU.Num_Proc_HIM				[Num_Proc],
	
--	'********** References ****************' + '|' +
--	'JOB.:' + HOU.Num_Proc_HIM + '|' +	
--	'Grupo: ' + isnull(PP.Apelido,'') + '|' +
--	'Consignatario: ' + isnull(CLI.Apelido	,'') + '|' +
--	'Navio: ' + isnull(HOU.Navio_HIM,'') + '|' +
--	'ETD: ' + isnull(convert(varchar(20),LLP.ETD_Lim,103),'') + '|' +
--	'ATD: ' + isnull(convert(varchar(20),LLP.ATD_lim,103),'') + '|' +
--	'ETA: ' + isnull(convert(varchar(20),LLP.ETA_Lim,103),'') + '|' +
--	'ATA: ' + isnull(convert(varchar(20),LLP.ATA_Lim,103),'') + '|' +
--	'HBL: ' + isnull(HOU.HAWB_HIM,'') + '|' +
--	'MBL: ' + isnull(HOU.MAWB_HIM,'') + '|' +
--	'Tipo da Carga: ' + isnull(TC.Nome_Tp_Carga,'') + '|' +
--	'Origem: ' + isnull(ORG.Nome_Local,'') + '|' +
--	'Destino: ' + isnull(DST.Nome_Local	,'') + '|' +	
--	'PDF - DOC Embarque no JOB: ' + isnull(Case when DC20.Id_DC='20' then 'SIM' else 'NÂO' End	,'') + '|' +
--	'PDF - BL Original no JOB: ' + isnull(Case when DC44.Id_DC='44' then 'SIM' else 'NÂO' End,'') + '|' +
--	'BDP Produto: ' + isnull(B.Nome_BDP_Produto	,'') + '|' +
--	'Status: ' + isnull(S.Status_Descricao	,'') + '|' +	
--	'*************************************'  + '|' +
--	'by BDP System' 				[Mensagem],
	
--	U.Nome_Usuario					[Usuario],
--	U.Email							[ResponderPara],
--	convert(date,GETDATE()) ,
--	convert(date,(T42A.Dt_Ins + @dias))
--from House_Imp_Mar HOU			with(nolock)
--	join LLP_Imp_Mar LLP		with(nolock) on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
--	Join Pessoa CLI				with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
--	left Join Pessoa_LLP PLLP	with(nolock)  on cd_consig_him=PLLP.cd_pes
--	left Join Pessoa PP			with(nolock)  on PP.cd_pes=cd_pes_grupo	
--	join Job_Imp_Mar JOB		with(nolock) on JOB.Num_Proc_HIM = HOU.Num_Proc_HIM
--	left JOIN Usuario U			with(nolock) on U.Cd_Usuario = JOB.cd_usuario
--	join Campo_Processo CP		with(nolock) on CP.Num_Proc = HOU.Num_proc_him and CP.Id_Campo = 143
--	left join BDP_Produto B		with(nolock) on B.ID_PD = CP.Campo_Dados
--	left join Tipo_Carga TC		with(nolock) on TC.Cd_Tp_Carga = LLP.Cd_Tp_Carga
--	join Localidade ORG			with(nolock) on ORG.Cd_Local = HOU.Cd_Org_HIM
--	join Localidade DST			with(nolock) on DST.Cd_Local = HOU.Cd_Dst_HIM
--	join Tarefas_Processos	T42 With (Nolock) on T42.Num_Proc = HOU.Num_Proc_Him and T42.ID_Task = 42
--	left join Tarefas_Processos	T192 With (Nolock) on T192.Num_Proc = HOU.Num_Proc_Him and T192.ID_Task = 192	
--	left join Tipo_Status_Processo S on S.ID_Status = LLP.ID_Status
--	Left Outer Join Doc_Anexos DC20 with(nolock) on HOU.Num_Proc_HIM = DC20.Num_Proc and DC20.Id_DC = '20'
--	Left Outer Join Doc_Anexos DC44 with(nolock) on HOU.Num_Proc_HIM = DC44.Num_Proc and DC44.Id_DC = '44'
--	Left Outer Join Doc_Anexos DC29 with(nolock) on HOU.Num_Proc_HIM = DC29.Num_Proc and DC29.Id_DC = '29'	
--	join Tarefas_Processos_Alerta T42A With (Nolock) on T42A.Num_Proc = HOU.Num_Proc_Him and T42A.ID_Task = 42
--Where
--	T42.Dt_Conclusao is not null
--	and T192.Dt_Conclusao is null
--	and PLLP.cd_pes_grupo = @cd_pes_grupo
--	and LLP.Cd_Tp_Carga = 1 and	
--	CP.Campo_Dados in (1,3) and	
--	HOU.Cd_Dst_HIM = 'SSZ' and
--	Convert(datetime,HOU.Dt_Emis_HIM,103) > '2015-01-01' and 
--	(Isnull(LLP.ID_Status,1) not in (9,8,5))		
--	and convert(date,GETDATE()) = convert(date,(T42A.Dt_Ins + @dias))

--select * from [dbo].[Tipo_Alerta_Redestinacao]
--select * from [dbo].[Alerta_Email_Redestinacao]
--Falta da Confirmação da Redestinação
--spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel
--Alertas Falta da Confirmação da Redestinação - CSR / Supervisor / Coordenador / Gerente / Diretoria:
--1º Alerta - Enviar alerta ao CSR após 1 dia do preenchimento do Task - Redestinação e o não preenchimento do Task - 
--Confirmação da Redestinação; 
--2º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente após 2 dia 
--do preenchimento do Task - Redestinação e o não preenchimento do Task - Confirmação da Redestinação; 
--3º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente/Diretoria após 3 dia 
--do preenchimento do Task - Redestinação e o não preenchimento do Task - Confirmação da Redestinação; 
--[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel]'P21128',1
--[spRedestinacao_Rel]''
--select * from Pessoa where Apelido = 'GRUPO OXITENO'

--select * from Alerta_Email_Redestinacao where Status =1
--[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel] '1','0','0' - 'IMCSR201705003BR'
--[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel] '1','1','1' - 'IMCSR201612007BR'
--[spAlerta_Email_Falta_da_Confirmacao_de_Redestinacao_Rel] '1','2','5' - 'IMCSR201705002BR'
	
GO
