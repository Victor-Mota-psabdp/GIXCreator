SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteHEO_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteHEO_Sel 
(
@Num_Proc		VarChar(16) ='',
@CreditNote		VarChar(12) ='',
@RP_HEO		Char(1)=''
)
 AS
	If @CreditNote <> '' 
		Select  
			Nome_Tp_Tx_Ing, 
			DC_HEO, 
			Cd_Tp_Moeda, 
			Vlr_Org_HEO
		From  	
			Cta_Cte_Hou_Exp_Out, 
			Tipo_Taxa 
		Where 	
			Cta_Cte_Hou_Exp_Out.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx  and
			Num_DCN_HEO = @CreditNote and 
			Num_Proc_HEO = @Num_Proc 
		Order by  
			Cd_Tp_Moeda, 			
			Nome_Tp_Tx_Ing
	Else
		Begin 
			If @RP_HEO = '' 
				Select  
					Num_Proc_HEO, 
					Nome_Tp_Tx_Ing,
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Tx, 
					Nome_Tp_Tx, 
					DC_HEO, 
					Org_Ins_HEO, 
					Dt_Ins_HEO, 
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Moeda, 
					Nome_Tp_Moeda, 
					Vlr_Org_HEO, 
					Dt_Prev_Pgto_HEO, 
					Cd_Cred_Dev_HEO, 
					Desp_Org_HEO,	
					Apelido, 
					Desp_Org_HEO, 
					CPMF_HEO, 
					Comp_RP_HEO, 
					Comp_DN_HEO, 
					Comp_CN_HEO, 
					Comp_CPA_HEO, 
					Num_DCN_HEO,
					Dt_Ctb_CC_HEO
				From  	
					Cta_Cte_Hou_Exp_Out, 
					Tipo_Taxa, 
					Tipo_Moeda, 
					Pessoa 
				Where 	
					Num_Proc_HEO = @Num_Proc AND 
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
					Cd_Cred_Dev_HEO = Cd_Pes 
				Order by  
					Nome_Tp_Tx, DC_HEO
			Else 
				Select  
					Num_Proc_HEO, 
					Nome_Tp_Tx_Ing,
					Num_Proc_HEO + '-' + Cta_Cte_Hou_Exp_Out.Cd_Tp_Tx + '-' + DC_HEO as Seq,
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Tx, 
					Nome_Tp_Tx, 
					DC_HEO, 
					Org_Ins_HEO, 
					Dt_Ins_HEO, 
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Moeda, 
					Nome_Tp_Moeda, 
					Vlr_Org_HEO, 
					Dt_Prev_Pgto_HEO, 
					Cd_Cred_Dev_HEO, 
					Desp_Org_HEO,
					Apelido, 
					Desp_Org_HEO, 
					CPMF_HEO, 
					Comp_RP_HEO, 
					Comp_DN_HEO, 
					Comp_CN_HEO, 
					Comp_CPA_HEO, 
					Num_DCN_HEO,
					Dt_Ctb_CC_HEO
				From  	
					Cta_Cte_Hou_Exp_Out, 
					Tipo_Taxa, 
					Tipo_Moeda, 
					Pessoa 
				Where 	
					Num_Proc_HEO = @Num_Proc And 
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And
					Cta_Cte_Hou_Exp_Out.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda And  
					Cd_Cred_Dev_HEO = Cd_Pes And
					Comp_RP_HEO = @RP_HEO
				Order by  
					Nome_Tp_Tx, DC_HEO
				
		End
GO
