SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.pCtaCteHEA_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCteHEA_Sel 
(
@Num_Proc		VarChar(16) ='',
@CreditNote		VarChar(12) ='', 
@RP_HEA		Char(1)=''
)
 AS
	If @CreditNote <> '' 
		Select  
			Nome_Tp_Tx_Ing, 
			DC_HEA, 
			Cd_Tp_Moeda, 
			Vlr_Org_HEA
		From  	
			Cta_Cte_Hou_Exp_Aer, 
			Tipo_Taxa 
		Where 	
			Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx  and
			Num_DCN_HEA = @CreditNote and 
			Num_Proc_HEA = @Num_Proc 
		Order by  
			Cd_Tp_Moeda, 			
			Nome_Tp_Tx_Ing
	Else
		Begin 		
			If @RP_HEA = ''		
				Select  
					Num_Proc_HEA, 
					Nome_Tp_Tx_Ing,
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx, 
					Nome_Tp_Tx, 
					DC_HEA, 
					Org_Ins_HEA, 
					Dt_Ins_HEA, 
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Moeda, 
					Nome_Tp_Moeda, 
					Vlr_Org_HEA, 
					Dt_Prev_Pgto_HEA, 
					Cd_Cred_Dev_HEA, 
					Desp_Dst_HEA,
					Apelido, 
					Desp_Dst_HEA, 
					CPMF_HEA, 
					Comp_RP_HEA, 
					Comp_DN_HEA, 
					Comp_CN_HEA, 
					Comp_CPA_HEA, 
					Num_DCN_HEA,
					Dt_Ctb_CC_HEA, 
					Comp_HAWB_HEA
				From  	
					Cta_Cte_Hou_Exp_Aer, 
					Tipo_Taxa, 
					Tipo_Moeda, 
					Pessoa 
				Where 	
					Num_Proc_HEA = @Num_Proc AND 
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
					Cd_Cred_Dev_HEA = Cd_Pes 
				Order by  
					Nome_Tp_Tx, DC_HEA
			Else
				Select  
					Num_Proc_HEA, 
					Nome_Tp_Tx_Ing,
					Num_Proc_HEA + '-' + Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx + '-' + DC_HEA as Seq,
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx, 
					Nome_Tp_Tx, 
					DC_HEA, 
					Org_Ins_HEA, 
					Dt_Ins_HEA, 
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Moeda, 
					Nome_Tp_Moeda, 
					Vlr_Org_HEA, 
					Dt_Prev_Pgto_HEA, 
					Cd_Cred_Dev_HEA, 
					Desp_Dst_HEA,
					Apelido, 
					Desp_Dst_HEA, 
					CPMF_HEA, 
					Comp_RP_HEA, 
					Comp_DN_HEA, 
					Comp_CN_HEA, 
					Comp_CPA_HEA, 
					Num_DCN_HEA,
					Dt_Ctb_CC_HEA, 
					Comp_HAWB_HEA
				From  	
					Cta_Cte_Hou_Exp_Aer, 
					Tipo_Taxa, 
					Tipo_Moeda, 
					Pessoa 
				Where 	
					Num_Proc_HEA = @Num_Proc And 
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And 
					Cta_Cte_Hou_Exp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda And 
					Cd_Cred_Dev_HEA = Cd_Pes And 
					Comp_RP_HEA = @RP_HEA
				Order by  
					Nome_Tp_Tx, DC_HEA				
		End
GO
