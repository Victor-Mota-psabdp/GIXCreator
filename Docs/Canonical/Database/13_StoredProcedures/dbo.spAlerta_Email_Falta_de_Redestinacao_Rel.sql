SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAlerta_Email_Falta_de_Redestinacao_Rel]
(
	@cd_pes_grupo as Varchar(6),
	@dia as int,
	@diafim as int
)

AS

--spAlerta_Email_Falta_de_Redestinacao_Rel '10017',0,5

--declare @cd_pes_grupo as Varchar(6)
--declare	@dia as int
--declare	@diafim as int

--set @cd_pes_grupo = '10017'
--set @dia = 0
--set @diafim = 5



Select 
	HOU.Num_Proc_HIM										[JOB],
	''														[Doc_Anexos],
	''														[Doc_Anexos_Nao_Obrigatorios],
	'Falta de Redestinação - JOB.:' + HOU.Num_Proc_HIM 
	+ ' - ETA: ' + isnull(convert(varchar(20),LLP.ETA_Lim,103),'') 	[Assunto],
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
	
	GETDATE()						[Previsao],
	NULL							[CD_Pes_Grupo],
	''								[Nome_Tp_Ocor],
	NULL							[ID],
	''								[Nome_Task],
	''								[Emails],
	--NULL							[ResponderPara],
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
		
	convert(date,GETDATE()) DATA_HOJE,
	convert(date,LLP.ETA_Lim) DATA_ETA,
	convert(date,(GETDATE() + @Dia)) DATA_Inicio,
	convert(date,(GETDATE() + @diafim)) DATA_fim,
	Org.Pais_Local	
	
from House_Imp_Mar HOU with(nolock)
	join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	join Job_Imp_Mar JOB with(nolock) on JOB.Num_Proc_HIM = HOU.Num_Proc_HIM
	left JOIN Usuario U on U.Cd_Usuario = JOB.cd_usuario
	join Campo_Processo CP  with(nolock) on CP.Num_Proc = HOU.Num_proc_him and CP.Id_Campo = 143
	left join BDP_Produto B with(nolock) on B.ID_PD = CP.Campo_Dados
	left join Tipo_Carga TC with(nolock) on TC.Cd_Tp_Carga = LLP.Cd_Tp_Carga
	join Localidade ORG on ORG.Cd_Local = HOU.Cd_Org_HIM
	join Localidade DST on DST.Cd_Local = HOU.Cd_Dst_HIM
	Left join Tarefas_Processos	T42 With (Nolock) on T42.Num_Proc = HOU.Num_Proc_Him and T42.ID_Task = 42	
	left join Tipo_Status_Processo S on S.ID_Status = LLP.ID_Status
	Left Outer Join Doc_Anexos DC20 with(nolock) on HOU.Num_Proc_HIM = DC20.Num_Proc and DC20.Id_DC = '20'
	Left Outer Join Doc_Anexos DC44 with(nolock) on HOU.Num_Proc_HIM = DC44.Num_Proc and DC44.Id_DC = '44'
	Left Outer Join Doc_Anexos DC29 with(nolock) on HOU.Num_Proc_HIM = DC29.Num_Proc and DC29.Id_DC = '29'	

Where	
	--HOU.Num_Proc_HIM= 'IMCSR201804002BR' and 
	T42.Dt_Conclusao is null
	and (PLLP.cd_pes_grupo = @cd_pes_grupo or @cd_pes_grupo = '10017')
	and LLP.Cd_Tp_Carga = 1 and	
	CP.Campo_Dados in (1,3) and	
	HOU.Cd_Dst_HIM = 'SSZ' and
	Convert(datetime,HOU.Dt_Emis_HIM,103) > '2015-01-01' and 
	(Isnull(LLP.ID_Status,1) not in (9,8,5))	
	and 	
		convert(date,LLP.ETA_LIM)  between convert(date,GETDATE()+ @dia)  and convert(date,GETDATE()+ (@diafim))
	
	--and
	--(
	--	(upper(Org.Pais_Local) = 'ARGENTINA' and convert(date,LLP.ETA_LIM) 
	--		between convert(date,GETDATE()+ @dia) and convert(date,GETDATE()+ (@diafim)))
	--		or 
	--	(upper(Org.Pais_Local) <> 'ARGENTINA' and convert(date,LLP.ETA_LIM) 
	--		between convert(date,GETDATE()+ @dia) and convert(date,GETDATE()+ (@diafim)))
	--)
	
	
	

----select * from [dbo].[Tipo_Alerta_Redestinacao]

----select * from [dbo].[Alerta_Email_Redestinacao]

----Alertas Falta da Redestinação - CSR / Supervisor / Coordenador / Gerente / Diretoria:
----1º Alerta - Enviar alerta ao CSR  -5 dias para o ETA e o Task - Redestinação ainda não estiver preenchido; 
----2º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente  -4 dias para o ETA e 
----o Task - Redestinação ainda não estiver preenchido; 
----3º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente/Diretoria  -3 dias para o ETA 
----e o Task - Redestinação ainda não estiver preenchido.
----[spAlerta_Email_Falta_de_Redestinacao_Rel]'P21128',3
----[spRedestinacao_Rel]''
----select * from Pessoa where Apelido = 'GRUPO OXITENO'

--ALTER procedure [dbo].[spAlerta_Email_Falta_de_Redestinacao_Rel]
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
	
--	convert(date,GETDATE()) DATA,
--	convert(date,(LLP.ETA_Lim - @Dias)) DATA_Dias,
--	Org.Pais_Local
--from House_Imp_Mar HOU with(nolock)
--	join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
--	join Job_Imp_Mar JOB with(nolock) on JOB.Num_Proc_HIM = HOU.Num_Proc_HIM
--	left JOIN Usuario U on U.Cd_Usuario = JOB.cd_usuario
--	join Campo_Processo CP  with(nolock) on CP.Num_Proc = HOU.Num_proc_him and CP.Id_Campo = 143
--	left join BDP_Produto B with(nolock) on B.ID_PD = CP.Campo_Dados
--	left join Tipo_Carga TC with(nolock) on TC.Cd_Tp_Carga = LLP.Cd_Tp_Carga
--	join Localidade ORG on ORG.Cd_Local = HOU.Cd_Org_HIM
--	join Localidade DST on DST.Cd_Local = HOU.Cd_Dst_HIM
--	Left join Tarefas_Processos	T42 With (Nolock) on T42.Num_Proc = HOU.Num_Proc_Him and T42.ID_Task = 42	
--	left join Tipo_Status_Processo S on S.ID_Status = LLP.ID_Status
--	Left Outer Join Doc_Anexos DC20 with(nolock) on HOU.Num_Proc_HIM = DC20.Num_Proc and DC20.Id_DC = '20'
--	Left Outer Join Doc_Anexos DC44 with(nolock) on HOU.Num_Proc_HIM = DC44.Num_Proc and DC44.Id_DC = '44'
--	Left Outer Join Doc_Anexos DC29 with(nolock) on HOU.Num_Proc_HIM = DC29.Num_Proc and DC29.Id_DC = '29'	

--Where	
--	--HOU.Num_Proc_HIM= 'IMOXT201612001BR' and 
--	T42.Dt_Conclusao is null
--	and PLLP.cd_pes_grupo = @cd_pes_grupo		
--	and LLP.Cd_Tp_Carga = 1 and	
--	CP.Campo_Dados in (1,3) and	
--	HOU.Cd_Dst_HIM = 'SSZ' and
--	Convert(datetime,HOU.Dt_Emis_HIM,103) > '2015-01-01' and 
--	(Isnull(LLP.ID_Status,1) not in (9,8,5))
	
--	and 
--	(
--		(Org.Pais_Local = 'Argentina' and convert(date,GETDATE()) = convert(date,(LLP.ETA_Lim - (@Dias-2))))
--			or 
--		(Org.Pais_Local <> 'Argentina' and convert(date,GETDATE()) = convert(date,(LLP.ETA_Lim - @Dias)))
--	)

--select * from [dbo].[Tipo_Alerta_Redestinacao]
--select * from [dbo].[Alerta_Email_Redestinacao]
--Alertas Falta da Redestinação - CSR / Supervisor / Coordenador / Gerente / Diretoria:
--1º Alerta - Enviar alerta ao CSR  -5 dias para o ETA e o Task - Redestinação ainda não estiver preenchido; 
--2º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente  -4 dias para o ETA e 
--o Task - Redestinação ainda não estiver preenchido; 
--3º Alerta - Enviar alerta ao CSR/Supervisor/Coordenador/Gerente/Diretoria  -3 dias para o ETA 
--e o Task - Redestinação ainda não estiver preenchido.
--[spAlerta_Email_Falta_de_Redestinacao_Rel]'P21128',3
--[spRedestinacao_Rel]''
--select * from Pessoa where Apelido = 'GRUPO OXITENO'

--select * from Tipo_Alerta_Redestinacao
--select * from Alerta_Email_Redestinacao where Status =1
--[spAlerta_Email_Falta_de_Redestinacao_Rel] '1','1','2'

--[spAlerta_Email_Falta_de_Redestinacao_Rel] '1','0','0' - 'IMCSR201705003BR'
--[spAlerta_Email_Falta_de_Redestinacao_Rel] '1','1','1' - 'IMCSR201612007BR'
--[spAlerta_Email_Falta_de_Redestinacao_Rel] '1','2','5' - 'IMCSR201705002BR'
--[spAlerta_Email_Falta_de_Redestinacao_Rel] '1','6','10' - 'IMCSR201611004BR'
	
	
	

GO
