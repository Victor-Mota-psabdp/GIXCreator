SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spHBO_Sel]
(
	@Processo		VarChar(16)
)
AS
	Select  
--House_IMP_out
		convert(datetime,Dt_Emis_HBO,103) Dt_Emis_HBO,
		Descr_Serv_HBO,
		
		HOU.cd_tp_oper,
		INC.Nome_Tp_Oper,
		
--LLP_imp_out
		CSR.Nome_Usuario Usuario,
		LLP.Id_tp_servico,
		TBO.Nome_tp_servico,
		--Grupo.Apelido BDPGrupo,
		--LLP.Cd_Pes_Grupo cd_grupo,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		Cliente.Apelido Cliente,
		HOU.Cd_cliente_HBO Cd_cliente_HBO,
		convert(varchar(10),isnull(LLP.PO_Req_Date,GETDATE()),103) PO_Req_Date,
		
		C143.Campo_Dados ID_PD,
		BDP.Nome_BDP_Produto
	From  
		House_BDP_OUT HOU
		Left Outer Join LLP_BDP_OUT	LLP				on HOU.Num_proc_HBO = LLP.Num_proc_LBO
		Left Outer Join Tipo_Servico TBO			on TBO.Id_tp_servico = LLP.Id_tp_servico 
		Left Outer Join Usuario		CSR				on LLP.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Tipo_Status_BO [Status]		on [Status].id_status=LLP.id_status	
		--Left Outer Join Pessoa		Grupo			on LLP.Cd_Pes_Grupo = Grupo.Cd_Pes
		Left Outer Join Pessoa		Cliente			on HOU.Cd_cliente_HBO = Cliente.Cd_Pes
		
		Left Outer Join Tipo_Oper INC			on INC.Cd_Tp_Oper = HOU.cd_tp_oper
		
		Left Outer Join Campo_Processo C143 on C143.Num_Proc = HOU.Num_proc_HBO and C143.Id_Campo = 143
		Left Outer Join BDP_Produto BDP	on BDP.ID_PD  = C143.Campo_Dados 
	Where
		HOU.Num_Proc_HBO= @Processo 
GO
