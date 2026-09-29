SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwAlerta_Email_Doc_Automatico_Sel] 

AS

		Select 
			A.ID_Alerta				[Code],
			A.ID					[ID],
			A.Id_Task				[Task Code],
			Nome_Task				[Task Name],

			A.Cd_Pes_Grupo			[Group Code],
			(case when (A.Cd_Pes_Grupo = 'ALL' OR A.Cd_Pes_Grupo = '10017') then 'ALL GROUPS' else
				P.Apelido end)		[Group Name],

			A.cd_pes				[Client Code],
			(case when (A.cd_pes = 'ALL' OR A.cd_pes IS NULL) then 'ALL Clients' else
				PP.Apelido end)		[Client Name],

			A.Cd_Pes_Out			[Supplier Code],
			(case when (A.Cd_Pes_Out = 'ALL' or A.Cd_Pes_Out is null) then 'ALL Suppliers' else
				PPO.Apelido end)	[Supplier Name],

			A.Modal					[Modal Code],
			TM.Nome_TP_MODAL		[Modal Name],
			Dias					[Days],
			ResponderPara			[Reply to:],
			Emails					[Sent To:],
			CopyBDP					[Copy To:],
			Doc_Anexos				[Documents Yes],
			Doc_Anexos_Nao			[Documents No],	
			Assunto					[Subject],
			Mensagem				[Body],			
			A.Dt_Ins				[Insert Date],
			A.Cd_Usuario			[User Code],
			Nome_Usuario			[User Name],
			A.Ativo					[Enabled],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Email_do_CompanyRegister [Emails from Company Register],

			A.cd_tp_carga			[Type Of Cargo Code],
			(case when (A.cd_tp_carga = 0 or A.cd_tp_carga IS null) then 'ALL Types'
				else Nome_tp_Carga end) [Type Of Cargo Name],

			A.cd_org				[Origin Code],
			(case when (A.cd_org = 'ALL'  or A.cd_org IS null) then 'ALL Origins' else Org.Nome_Local end) [Origin Name],

			A.cd_dst			[Destination Code],
			(case when (A.cd_dst = 'ALL'  or A.cd_dst IS null) then 'ALL Destinations' else Dst.Nome_Local end) [Destination Name],			
			A.StandardForms         [Standard Forms],

			A.cd_tp_pedido			[Order Type Code],
			(case when (A.cd_tp_pedido = '1'  or A.cd_tp_pedido IS null) then '1 - All'  else 
				A.cd_tp_pedido + ' - ' + TP.nome_tp_pedido end) [Order Type Name],

			Email_do_Agente_Consolidado [Emails from Consol.],

			A.cd_transportadora		[Inland Trucker Code],
			(case when (A.cd_transportadora = 'ALL' or A.cd_transportadora is null)  then 'ALL Inland Trucker' else
				T.Apelido end)		[Inland Trucker Name],
			CopyEmail			[Copy Email],

			A.cd_terminal			[Terminal Code],
			(case when (A.cd_terminal = 'ALL' or A.cd_terminal is null) then 'ALL Terminals' else
				TE.Nome_Terminal end) [Terminal Name],
			Zip,

			A.Id_NCM						[NCM Code],	
			(case when (A.Id_NCM = '0' or A.Id_NCM is null) then 'ALL NCMs' else
				NCM.NCM end)				[NCM Name],

			A.Cd_Pes_Agent					[Agent Code],
			(case when (A.Cd_Pes_Agent = 'ALL' or A.Cd_Pes_Agent is null) then 'ALL Agents' else
				Agent.Apelido end)			[Agent Name],

			A.Id_Necessidade_LI				[License Import Mandatory Code],
			(case when (A.Id_Necessidade_LI = '0' or A.Id_Necessidade_LI is null) then 'ALL LI Mandatory' else
				LI.Descricao end)			[License Import Mandatory Name],

			
			A.Cd_Armador					[Carrier Code],
			(case when (A.Cd_Armador = 'ALL' or A.Cd_Armador is null) then 'ALL Carriers' else
				(Case when right(A.Modal,1) = 'M' then Armador.Nome_Armador else 
					(Case when right(A.Modal,1) = 'A' then CiaAer.Nome_Cia_Aer else 
						Armador_OUT.Apelido end)end)end) [Carrier Name],
		
			A.Cd_Tp_Cont					[Container Type Code],
			(case when (A.Cd_Tp_Cont = 'ALL' or A.Cd_Tp_Cont is null) then 'ALL Containers Type' else
				TCO.Nome_Tp_Cont end)				[Container Type Name],
			A.Cd_Prod					[Client Product Code],
			(case when (A.Cd_Prod = '0' or A.Cd_Prod is null) then 'ALL Client Products' else
				PC.cd_Proc_Cliente end)				[Client Product Name]

		from 
			Alerta_Email_Doc_Automatico		A		with(nolock)
			left join Pessoa				P		with(nolock) on P.Cd_Pes		= A.cd_pes_grupo
			join Usuario					U		with(nolock) on U.Cd_Usuario	= A.Cd_Usuario
			left join tipo_carga			TC		with(nolock) on TC.Cd_Tp_Carga	= A.Cd_Tp_Carga
			left join Tipo_Modal_Imp_Exp	TM		with(nolock) on TM.CD_TP_MODAL	= A.Modal		
			left join Localidade			Org		with(nolock) on Org.Cd_Local	= A.cd_org
			left join Localidade			Dst		with(nolock) on Dst.Cd_Local	= A.cd_dst
			left join Tipo_pedido			TP		with(nolock) on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
			left join Pessoa				PP		with(nolock) on PP.Cd_Pes		= A.Cd_Pes
			left join Pessoa				PPO		with(nolock) on PPO.Cd_Pes		= A.Cd_Pes_Out
			left join Pessoa				T		with(nolock) on T.Cd_Pes		= A.cd_transportadora
			left join Terminal				TE		with(nolock) on TE.Cd_Terminal	= A.Cd_Terminal

			left join NCM					NCM			with(nolock) on NCM.Id_NCM			= A.Id_NCM
			left join Pessoa				Agent		with(nolock) on Agent.Cd_Pes		= A.Cd_Pes_Agent
			left join Verdade				LI			with(nolock) on LI.Id				= A.Id_Necessidade_LI 
			left join Armador				Armador		with(nolock) on Armador.Cd_Armador	= A.Cd_Armador
			left join Cia_Aerea				CiaAer		with(nolock) on CiaAer.Cd_Cia_Aer	= A.Cd_Armador
			left join Pessoa				Armador_OUT with(nolock) on Armador_OUT.Cd_Pes	= A.Cd_Armador 
			left join Tipo_Container		TCO			with(nolock) on TCO.Cd_Tp_Cont		= A.Cd_Tp_Cont
			left join Produto_Cliente		PC			with(nolock) on PC.Cd_Prod			= A.Cd_Prod

	--Select 
	--		A.ID_Alerta				[Code],
	--		A.ID					[ID],
	--		A.Id_Task				[Task Code],
	--		Nome_Task				[Task Name],
	--		A.Cd_Pes_Grupo			[Group Code],
	--		(case when A.Cd_Pes_Grupo = 'ALL' then 'ALL GROUPS' else
	--			P.Apelido end)		[Group Name],
	--		A.cd_pes				[Client Code],
	--		(case when A.cd_pes = 'ALL' then 'ALL Clients' else
	--			PP.Apelido end)		[Client Name],
	--		A.Cd_Pes_Out			[Supplier Code],
	--		(case when (A.Cd_Pes_Out = 'ALL' or A.Cd_Pes_Out is null) then 'ALL Suppliers' else
	--			PPO.Apelido end)	[Supplier Name],
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
	--		A.StandardForms         [Standard Forms],
	--		TP.cd_tp_pedido			[Order Type Code],
	--		TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [Order Type Name],
	--		Email_do_Agente_Consolidado [Emails from Consol.],
	--		A.cd_transportadora		[Inland Trucker Code],
	--		(case when (A.cd_transportadora = 'ALL' or A.cd_terminal is null)  then 'ALL Inland Trucker' else
	--			T.Apelido end)		[Inland Trucker Name],
	--		CopyEmail			[Copy Email],
	--		A.cd_terminal			[Terminal Code],
	--		(case when (A.cd_terminal = 'ALL' or A.cd_terminal is null) then 'ALL Terminals' else
	--			TE.Nome_Terminal end) [Terminal Name],
	--		Zip,

	--		A.Id_NCM						[NCM Code],	
	--		(case when (A.Id_NCM = '0' or A.Id_NCM is null) then 'ALL NCMs' else
	--			NCM.NCM end)				[NCM Name],

	--		A.Cd_Pes_Agent					[Agent Code],
	--		(case when (A.Cd_Pes_Agent = 'ALL' or A.Cd_Pes_Agent is null) then 'ALL Agents' else
	--			Agent.Apelido end)			[Agent Name],

	--		A.Id_Necessidade_LI				[Necessidade de LI Code],
	--		(case when (A.Id_Necessidade_LI = '0' or A.Id_Necessidade_LI is null) then 'ALL Necessidade de LI' else
	--			LI.Descricao end)			[Necessidade de LI Name],

	--		A.Cd_Armador					[Carrier Maritime Code],
	--		(case when (A.Cd_Armador = 'ALL' or A.Cd_Armador is null) then 'ALL Carrier Maritime' else
	--			Armador.Nome_Armador end)				[Carrier Maritime Name],

	--		A.Cd_Cia_Aer					[Air Company Code],
	--		(case when (A.Cd_Cia_Aer = 'ALL' or A.Cd_Cia_Aer is null) then 'ALL Air Company' else
	--			CiaAer.Nome_Cia_Aer end)				[Air Company Name],

	--		A.Cd_Pes_Armador				[Carrier Others Code],
	--		(case when (A.Cd_Pes_Armador = 'ALL' or A.Cd_Pes_Armador is null) then 'ALL Carrier Others' else
	--			Armador_OUT.Apelido end)				[Carrier Others Name],
	--		A.Cd_Tp_Cont					[Container Type Code],
	--		(case when (A.Cd_Tp_Cont = 'ALL' or A.Cd_Tp_Cont is null) then 'ALL Containers Type' else
	--			TCO.Nome_Tp_Cont end)				[Container Type Name]

	--	from 
	--		Alerta_Email_Doc_Automatico		A		with(nolock)
	--		left join Pessoa				P		with(nolock) on P.Cd_Pes		= A.cd_pes_grupo
	--		join Usuario					U		with(nolock) on U.Cd_Usuario	= A.Cd_Usuario
	--		left join tipo_carga			TC		with(nolock) on TC.Cd_Tp_Carga	= A.Cd_Tp_Carga
	--		left join Tipo_Modal_Imp_Exp	TM		with(nolock) on TM.CD_TP_MODAL	= A.Modal		
	--		left join Localidade			Org		with(nolock) on Org.Cd_Local	= A.cd_org
	--		left join Localidade			Dst		with(nolock) on Dst.Cd_Local	= A.cd_dst
	--		left join Tipo_pedido			TP		with(nolock) on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
	--		left join Pessoa				PP		with(nolock) on PP.Cd_Pes		= A.Cd_Pes
	--		left join Pessoa				PPO		with(nolock) on PPO.Cd_Pes		= A.Cd_Pes_Out
	--		left join Pessoa				T		with(nolock) on T.Cd_Pes		= A.cd_transportadora
	--		left join Terminal				TE		with(nolock) on TE.Cd_Terminal	= A.Cd_Terminal

	--		left join NCM					NCM			with(nolock) on NCM.Id_NCM			= A.Id_NCM
	--		left join Pessoa				Agent		with(nolock) on Agent.Cd_Pes		= A.Cd_Pes_Agent
	--		left join Verdade				LI			with(nolock) on LI.Id				= A.Id_Necessidade_LI 
	--		left join Armador				Armador		with(nolock) on Armador.Cd_Armador	= A.Cd_Armador
	--		left join Cia_Aerea				CiaAer		with(nolock) on CiaAer.Cd_Cia_Aer	= A.Cd_Cia_Aer
	--		left join Pessoa				Armador_OUT with(nolock) on Armador_OUT.Cd_Pes	= A.Cd_Pes_Armador 
	--		left join Tipo_Container		TCO			with(nolock) on TCO.Cd_Tp_Cont		= A.Cd_Tp_Cont
	
	--Select 
	--	A.ID_Alerta				[Code],
	--	A.Id_Task				[Task Code],
	--	Nome_Task				[Task Name],
	--	A.Cd_Pes_Grupo			[Group Code],
	--	(case when A.Cd_Pes_Grupo = 'ALL' then 'ALL GROUPS' else
	--		P.Apelido end)		[Group Name],
	--	A.cd_pes				[Principal Client Code],
	--	(case when A.cd_pes = 'ALL' then 'ALL Clients' else
	--		PP.Apelido end)		[Principal Client Name],
	--	A.Cd_Pes_Out			[Secondary Client Code],
	--	(case when A.Cd_Pes_Out = 'ALL' then 'ALL Clients' else
	--		PPO.Apelido end)		[Secondary Client Name],
	--	Modal					[Modal Code],
	--	TM.Nome_TP_MODAL		[Modal Name],
	--	Dias					[Days],
	--	ResponderPara			[Reply to:],
	--	Emails					[Sent To:],
	--	CopyBDP					[Copy To:],
	--	Doc_Anexos				[Documents Yes],
	--	Doc_Anexos_Nao			[Documents No],	
	--	Assunto					[Subject],
	--	Mensagem				[Body],			
	--	A.Dt_Ins				[Insert Date],
	--	A.Cd_Usuario			[User Code],
	--	Nome_Usuario			[User Name],
	--	A.Ativo					[Enabled],
	--	Nome_Tp_Ocor			[Occurrence Type Name],
	--	Email_do_CompanyRegister [Emails from Company Register],
	--	A.cd_tp_carga			[Type Of Cargo Code],
	--	(case when A.cd_tp_carga = 0 or A.cd_tp_carga IS null then 'ALL Types'
	--		else Nome_tp_Carga end) [Type Of Cargo Name],
	--	A.cd_org				[Origin Code],
	--	(case when A.cd_org = 'ALL' then 'ALL' else Org.Nome_Local end) [Origin Name],
	--		A.cd_dst			[Destination Code],
	--	(case when A.cd_dst = 'ALL' then 'ALL' else Dst.Nome_Local end) [Destination Name],			
	--	[StandardForms],
	--	TP.cd_tp_pedido			[Order Type Code],
	--	TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [Order Type Name],
	--	Email_do_Agente_Consolidado [Emails from Consol.],
	--	A.cd_transportadora		[Inland Trucker Code],
	--	(case when A.cd_transportadora = 'ALL' then 'ALL Inland Trucker' else
	--		T.Apelido end)		[Inland Trucker Name],
	--	CopyEmail			[Copy Email],
	--	A.cd_terminal			[Terminal Code],
	--	(case when A.cd_terminal = 'ALL' then 'ALL TERMINALS' else
	--		TE.Nome_Terminal end) [Terminal Name],
	--	Zip
	--from 
	--	Alerta_Email_Doc_Automatico		A	 with(nolock)
	--	left join Pessoa				P	with(nolock) on P.Cd_Pes = A.cd_pes_grupo
	--	join Usuario					U	with(nolock) on U.Cd_Usuario = A.Cd_Usuario
	--	left join tipo_carga			TC	with(nolock) on TC.Cd_Tp_Carga = A.Cd_Tp_Carga
	--	left join Tipo_Modal_Imp_Exp	TM  with(nolock) on TM.CD_TP_MODAL = A.Modal		
	--	left join Localidade			Org with(nolock) on Org.Cd_Local = A.cd_org
	--	left join Localidade			Dst with(nolock) on Dst.Cd_Local = A.cd_dst
	--	left join Tipo_pedido			TP	with(nolock) on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
	--	left join Pessoa				PP	with(nolock) on PP.Cd_Pes = A.Cd_Pes
	--	left join Pessoa				PPO with(nolock) on PPO.Cd_Pes = A.Cd_Pes_Out
	--	left join Pessoa				T	with(nolock) on T.Cd_Pes = A.cd_transportadora
	--	left join Terminal				TE	with(nolock) on TE.Cd_Terminal = A.Cd_Terminal 	



--ALTER view [dbo].[vwAlerta_Email_Doc_Automatico_Sel] 

--AS
	
--	Select 
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
