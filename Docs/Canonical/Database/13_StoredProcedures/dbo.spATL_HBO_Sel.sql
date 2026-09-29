SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_HBO_Sel]
(
	@Num_Proc	VarChar(16),
	@Tipo		char(1)
)
AS

--if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select  
	--House_IMP_out
			HOU.Num_Proc_HBO					[JOB],
			convert(datetime, Dt_Emis_HBO,103)	[Register Date],			
			Descr_Serv_HBO						[Service Description],					
			HOU.Cd_Tp_Oper						[Incoterm Code],
			TP.Nome_tp_Oper						[Incoterm Name],		
	--LLP_imp_out
			LLP.Cd_Usuario						[Customer Code],
			CSR.Nome_Usuario					[Customer Name],			
			LLP.Id_tp_servico					[Service Type Code],
			TBO.Nome_tp_servico					[Service Type Name],
			LLP.id_status						[Status Code],
			Status.Status_Descricao 			[Status Name],	
			HOU.Cd_cliente_HBO					[Client Code],
			Cliente.Apelido 					[Client Name],
			isnull(LLP.PO_Req_Date,GETDATE())  [PO Req. Del. Date],
			C143.Campo_Dados					[BDP Product Code],
			BDP.Nome_BDP_Produto				[BDP Product Name],
			PLLP.Cd_Pes_grupo 					[Group Code],
			PG.Apelido							[Group Name],
			Modal.cd_tp_modal					[Modal Code],
			Modal.Nome_Tp_Modal					[Modal Name]	
		From  
			House_BDP_OUT					HOU		with(nolock)
			Left Outer Join LLP_BDP_OUT		LLP		with(nolock) on HOU.Num_proc_HBO	= LLP.Num_proc_LBO
			Left Outer Join Pessoa_llp		PLLP	with(nolock) on HOU.Cd_cliente_HBO	= PLLP.Cd_Pes
			Left Outer Join Pessoa			PG		with(nolock) on PG.Cd_Pes			= PLLP.Cd_Pes_grupo
			Left Outer Join Tipo_Servico	TBO		with(nolock) on TBO.Id_tp_servico	= LLP.Id_tp_servico 
			Left Outer Join Usuario			CSR		with(nolock) on LLP.Cd_Usuario		= CSR.Cd_Usuario
			Left Outer Join Tipo_Status_BO	[Status] with(nolock) on [Status].id_status	=LLP.id_status			
			Left Outer Join Pessoa			Cliente	with(nolock) on HOU.Cd_cliente_HBO	= Cliente.Cd_Pes		
			Left Outer Join Tipo_Oper		TP		with(nolock) on TP.Cd_Tp_Oper		= HOU.cd_tp_oper
			Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock) on Modal.cd_tp_modal	= left(HOU.Num_proc_HBO,2)
			Left Outer Join Campo_Processo	C143	with(nolock) on C143.Num_Proc		= HOU.Num_proc_HBO and C143.Id_Campo = 143
			Left Outer Join BDP_Produto		BDP		with(nolock) on BDP.ID_PD			= C143.Campo_Dados 
		Where
			HOU.Num_Proc_HBO= @Num_Proc
		
	END

GO
