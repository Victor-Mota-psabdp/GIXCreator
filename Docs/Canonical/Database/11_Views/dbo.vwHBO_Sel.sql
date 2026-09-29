SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwHBO_Sel]
AS
SELECT  Num_Proc_HBO AS [01_JOB],
		Dt_Emis_HBO AS [02_Dt_Emis],
		Cliente.Apelido as [03_Cliente],
		TP.Nome_tp_Servico as [04_Tipo_Servico],
		
		--HOU.cd_tp_oper  as [05_Codigo_Incoterm],
		INC.Nome_Tp_Oper  as [05_Incoterm],
		--C143.Campo_Dados  as [07_Codigo_BDPProduto],
		BDP.Nome_BDP_Produto  as [06_BDP Produto]		 
			 
FROM dbo.House_BDP_OUT AS HOU
	Join LLP_BDP_OUT		LLP			on HOU.Num_Proc_HBO = LLP.Num_Proc_LBO
	--Join Pessoa				Grupo		on LLP.cd_pes_grupo = Grupo.Cd_Pes
	Join Pessoa				Cliente		on HOU.cd_cliente_HBO = Cliente.Cd_Pes
	Left join Tipo_Servico	TP		on LLP.id_tp_servico = TP.id_tp_servico
	
	Left Outer Join Tipo_Oper INC	on INC.Cd_Tp_Oper = HOU.cd_tp_oper
		
	Left Outer Join Campo_Processo C143 on C143.Num_Proc = HOU.Num_proc_HBO and C143.Id_Campo = 143
	Left Outer Join BDP_Produto BDP	on BDP.ID_PD  = C143.Campo_Dados 








GO
