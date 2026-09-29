SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.sp_baixa_cta_cte_hea    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE dbo.sp_baixa_cta_cte_hea 
@pnumprochea varchar(16) AS
SELECT Num_Proc_HEA, Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx, Nome_Tp_Tx,  DC_HEA, Desp_Dst_HEA, Cd_Cred_Dev_HEA, Apelido, Cta_Cte_Hou_Exp_Aer.Cd_Tp_Moeda, Nome_Tp_Moeda, Vlr_Org_HEA, Comp_RP_HEA 
FROM Cta_Cte_Hou_Exp_Aer, Tipo_Taxa, Pessoa, Tipo_Moeda 
WHERE Num_Proc_HEA = @pnumprochea AND Comp_RP_HEA = 'S' AND Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND Cd_Cred_Dev_HEA = Cd_Pes AND Cta_Cte_Hou_Exp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda;



GO
