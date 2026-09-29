SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteHIO_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteHIO_Sel 
(
@Num_Proc		VarChar(16),
@CreditNote		VarChar(12) ='', 
@RP_HIO		Char(1)=''
)
 AS
	If @RP_HIO = ''
		Select  
			Num_Proc_HIO, 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			Nome_Tp_Tx_Ing,
			DC_HIO, 
			Org_Ins_HIO, 
			Dt_Ins_HIO, 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_HIO, 
			Dt_Prev_Pgto_HIO, 
			Cd_Cred_Dev_HIO, 
			Apelido, 
			Desp_Org_HIO, 
			CPMF_HIO, 
			Comp_RP_HIO, 
			Comp_DN_HIO, 
			Comp_CN_HIO, 
			Comp_CPA_HIO,
			Num_DCN_HIO
		From  	
			Cta_Cte_Hou_Imp_Out, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Num_Proc_HIO = @Num_Proc AND 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_HIO = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_HIO
	Else
		Select  
			Num_Proc_HIO, 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Tx, 
			Num_Proc_HIO + '-' + Cta_Cte_Hou_Imp_Out.Cd_Tp_Tx + '-' + DC_HIO as Seq,
			Nome_Tp_Tx, 
			Nome_Tp_Tx_Ing,	
			DC_HIO, 
			Org_Ins_HIO, 
			Dt_Ins_HIO, 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_HIO, 
			Dt_Prev_Pgto_HIO, 
			Cd_Cred_Dev_HIO, 
			Apelido, 
			Desp_Org_HIO, 
			CPMF_HIO, 
			Comp_RP_HIO, 
			Comp_DN_HIO, 
			Comp_CN_HIO, 
			Comp_CPA_HIO,
			Num_DCN_HIO
		From  	
			Cta_Cte_Hou_Imp_Out, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Cta_Cte_Hou_Imp_Out.Num_Proc_HIO = @Num_Proc and 
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx and  
			Cta_Cte_Hou_Imp_Out.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda and  
			Cd_Cred_Dev_HIO = Cd_Pes and 
			Comp_RP_HIO = @RP_HIO
			
		Order by  
			Nome_Tp_Tx, DC_HIO
GO
