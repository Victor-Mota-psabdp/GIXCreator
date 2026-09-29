SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_ID_Sel](

	@ID as Bigint
)	
AS

	Select 
		A.ID					[ID],
		Nome_Task				[Task Name],
		(case when A.Cd_Pes_Grupo = 'ALL' then 'ALL GROUPS' else
			P.Apelido end)		[Group Name],		
		--P.Apelido				[Group Name],
		(case when A.cd_pes = 'ALL' then 'ALL Clients' else
			PP.Apelido end)		[Client Name],
		Modal					[Modal],
		Dias					[Days],
		ResponderPara			[Reply to:],
		Emails					[Sent To:],
		CopyBDP					[Copy To:],
		Doc_Anexos				[Documents Yes],
		Doc_Anexos_Nao			[Documents No],	
		Assunto					[Subject],
		Mensagem				[Body],			
		A.Dt_Ins					[Creation Date],
		Nome_Usuario			[User],
		A.Ativo,
		Email_do_CompanyRegister,
		(case when A.cd_tp_carga = 0 or A.cd_tp_carga IS null
			then 'ALL Types'
		else
			Nome_tp_Carga end) [TypeOfCargo],
		(case when A.cd_org = 'ALL' then 'ALL' else
			Org.Nome_Local end) [Origin],
		(case when A.cd_dst = 'ALL' then 'ALL' else
			Dst.Nome_Local end) [Destination],
			
		[StandardForms],
		TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [Order Type],
		Email_do_Agente_Consolidado,
		(case when A.cd_transportadora = 'ALL' then 'ALL Inland Trucker' else
			T.Apelido end)		[Inland Trucker],
		CopyEmail				[CopyEmail],
		(case when A.cd_terminal = 'ALL' then 'ALL TERMINALS' else
			TE.Nome_Terminal end)		[Terminal],
		Zip	
		
	from 
		Alerta_Email_Doc_Automatico A
		LEFT join Pessoa P on P.Cd_Pes = A.cd_pes_grupo
		join Usuario U on U.Cd_Usuario = A.Cd_Usuario
		left join tipo_carga TC on TC.Cd_Tp_Carga = A.Cd_Tp_Carga
		left join Localidade Org on Org.Cd_Local = A.cd_org
		left join Localidade Dst on Dst.Cd_Local = A.cd_dst
		left join Tipo_pedido TP on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
		left join Pessoa PP on PP.Cd_Pes = A.Cd_Pes
		left join Pessoa T on T.Cd_Pes = A.cd_transportadora 
		left join Terminal TE on TE.Cd_Terminal = A.Cd_Terminal
	where
		A.ID = @ID 
		
	order by 
		A.ID,Nome_Task,P.Apelido		
		





--ALTER procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_ID_Sel](

--	@ID as Bigint
--)	
--AS

--	Select 
--		A.ID					[ID],
--		Nome_Task				[Task Name],		
--		P.Apelido				[Group Name],
--		(case when A.cd_pes = 'ALL' then 'ALL Clients' else
--			PP.Apelido end)		[Client Name],
--		Modal					[Modal],
--		Dias					[Days],
--		ResponderPara			[Reply to:],
--		Emails					[Sent To:],
--		CopyBDP					[Copy To:],
--		Doc_Anexos				[Documents Yes],
--		Doc_Anexos_Nao			[Documents No],	
--		Assunto					[Subject],
--		Mensagem				[Body],			
--		Dt_Ins					[Creation Date],
--		Nome_Usuario			[User],
--		Ativo,
--		Email_do_CompanyRegister,
--		(case when A.cd_tp_carga = 0 or A.cd_tp_carga IS null
--			then 'ALL Types'
--		else
--			Nome_tp_Carga end) [TypeOfCargo],
--		(case when A.cd_org = 'ALL' then 'ALL' else
--			Org.Nome_Local end) [Origin],
--		(case when A.cd_dst = 'ALL' then 'ALL' else
--			Dst.Nome_Local end) [Destination],
			
--		[StandardForms],
--		TP.cd_tp_pedido + ' - ' + TP.nome_tp_pedido [Order Type],
--		Email_do_Agente_Consolidado,
--		(case when A.cd_transportadora = 'ALL' then 'ALL Inland Trucker' else
--			T.Apelido end)		[Inland Trucker]
		
		
--	from 
--		Alerta_Email_Doc_Automatico A
--		join Pessoa P on P.Cd_Pes = A.cd_pes_grupo
--		join Usuario U on U.Cd_Usuario = A.Cd_Usuario
--		left join tipo_carga TC on TC.Cd_Tp_Carga = A.Cd_Tp_Carga
--		left join Localidade Org on Org.Cd_Local = A.cd_org
--		left join Localidade Dst on Dst.Cd_Local = A.cd_dst
--		left join Tipo_pedido TP on TP.Cd_tp_Pedido = A.Cd_tp_Pedido
--		left join Pessoa PP on PP.Cd_Pes = A.Cd_Pes
--		left join Pessoa T on T.Cd_Pes = A.cd_transportadora 
--	where
--		A.ID = @ID
--	order by 
--		A.ID,Nome_Task,P.Apelido		
		




GO
