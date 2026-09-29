SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_Alerta_Email_Doc_Automatico_Sel] 

AS

Select distinct
		convert(Bigint,A.ID)	[ID],
		Nome_Task				[Task Name],		
		--P.Apelido				[Group Name],
		(case when A.Cd_Pes_Grupo = 'ALL' then 'ALL GROUPS' else
			P.Apelido end)		[Group Name],
		--Modal					[01_Modal],
		--Dias					[01_Days],
		--ResponderPara			[01_Reply to:],
		--Emails					[01_Sent To:],
		--CopyBDP					[01_Copy To:],
		--Doc_Anexos				[01_Documents Yes],
		--Doc_Anexos_Nao			[01_Documents No],	
		Assunto					[Subject],
		Mensagem				[Body],		
		--Dt_Ins					[01_Creation Date],
		Nome_Usuario			[User],
		Ativo,
		--Email_do_CompanyRegister [01_],
		--(case when A.cd_tp_carga = 0 or A.cd_tp_carga IS null
		--	then 'ALL Types'
		--else
		--	Nome_tp_Carga end) [01_TypeOfCargo],
		(case when A.cd_org = 'ALL' then 'ALL' else
			Org.Nome_Local end) [Origin],
		(case when A.cd_dst = 'ALL' then 'ALL' else
			Dst.Nome_Local end) [Destination]
			
		--[StandardForms] [01_],
		--TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [01_Order Type]		
	from 
		Alerta_Email_Doc_Automatico A
		left join Pessoa P on P.Cd_Pes = A.cd_pes_grupo
		join Usuario U on U.Cd_Usuario = A.Cd_Usuario
		left join tipo_carga TC on TC.Cd_Tp_Carga = A.Cd_Tp_Carga
		left join Localidade Org on Org.Cd_Local = A.cd_org
		left join Localidade Dst on Dst.Cd_Local = A.cd_dst
		left join Tipo_pedido TP on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
		left join Pessoa PP on PP.Cd_Pes = A.Cd_Pes
	
	--order by 
	--	A.ID,Nome_Task


--GO


--Select distinct
--		convert(Bigint,A.ID)	[ID],
--		A.ID_Alerta				[Code],
--		A.Id_Task				[Task Code],
--		Nome_Task				[Task Name],
--		A.Cd_Pes_Grupo			[Group Code],
--		(case when A.Cd_Pes_Grupo = 'ALL' then 'ALL GROUPS' else
--			P.Apelido end)		[Group Name],
--		A.cd_pes				[Principal Client Code],
--		(case when A.cd_pes = 'ALL' then 'ALL Clients' else
--			PP.Apelido end)		[Principal Client Name],
--		A.Cd_Pes_Out			[Secondary Client Code],
--		(case when A.Cd_Pes_Out = 'ALL' then 'ALL Clients' else
--			PPO.Apelido end)		[Secondary Client Name],
--		Modal					[Modal Code],
--		TM.Nome_TP_MODAL		[Modal Name],
--		Dias					[Days],
--		ResponderPara			[Reply to:],
--		Emails					[Sent To:],
--		CopyBDP					[Copy To:],
--		Doc_Anexos				[Documents Yes],
--		Doc_Anexos_Nao			[Documents No],	
--		Assunto					[Subject],
--		Mensagem				[Body],			
--		A.Dt_Ins				[Insert Date],
--		A.Cd_Usuario			[User Code],
--		Nome_Usuario			[User Name],
--		A.Ativo					[Enabled],
--		Nome_Tp_Ocor			[Occurrence Type Name],
--		Email_do_CompanyRegister [Emails from Company Register],
--		A.cd_tp_carga			[Type Of Cargo Code],
--		(case when A.cd_tp_carga = 0 or A.cd_tp_carga IS null then 'ALL Types'
--			else Nome_tp_Carga end) [Type Of Cargo Name],
--		A.cd_org				[Origin Code],
--		(case when A.cd_org = 'ALL' then 'ALL' else Org.Nome_Local end) [Origin Name],
--			A.cd_dst			[Destination Code],
--		(case when A.cd_dst = 'ALL' then 'ALL' else Dst.Nome_Local end) [Destination Name],			
--		[StandardForms],
--		TP.cd_tp_pedido			[Order Type Code],
--		TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [Order Type Name],
--		Email_do_Agente_Consolidado [Emails from Consol.],
--		A.cd_transportadora		[Inland Trucker Code],
--		(case when A.cd_transportadora = 'ALL' then 'ALL Inland Trucker' else
--			T.Apelido end)		[Inland Trucker Name],
--		CopyEmail			[Copy Email],
--		A.cd_terminal			[Terminal Code],
--		(case when A.cd_terminal = 'ALL' then 'ALL TERMINALS' else
--			TE.Nome_Terminal end) [Terminal Name],
--		Zip
--	from 
--		Alerta_Email_Doc_Automatico		A	 with(nolock)
--		left join Pessoa				P	with(nolock) on P.Cd_Pes = A.cd_pes_grupo
--		join Usuario					U	with(nolock) on U.Cd_Usuario = A.Cd_Usuario
--		left join tipo_carga			TC	with(nolock) on TC.Cd_Tp_Carga = A.Cd_Tp_Carga
--		left join Tipo_Modal_Imp_Exp	TM  with(nolock) on TM.CD_TP_MODAL = A.Modal		
--		left join Localidade			Org with(nolock) on Org.Cd_Local = A.cd_org
--		left join Localidade			Dst with(nolock) on Dst.Cd_Local = A.cd_dst
--		left join Tipo_pedido			TP	with(nolock) on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
--		left join Pessoa				PP	with(nolock) on PP.Cd_Pes = A.Cd_Pes
--		left join Pessoa				PPO with(nolock) on PPO.Cd_Pes = A.Cd_Pes_Out
--		left join Pessoa				T	with(nolock) on T.Cd_Pes = A.cd_transportadora
--		left join Terminal				TE	with(nolock) on TE.Cd_Terminal = A.Cd_Terminal 

	







GO
