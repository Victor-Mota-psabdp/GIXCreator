SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_GeraCtaCte_Veconinter_Ins]

	@num_proc as varchar(16),
	@vlr_org_him as decimal(10,2),
	@cd_tp_tx	as varchar(3),
	@cd_usuario as varchar(6)

as

--Criado pra fazer a despesa de Demurrage, eh utilizada no ATL2012 - Integration/Excel Integration/opção 01 - Veconinter

BEGIN TRANSACTION
	-- VERIFICA SE EXISTE A TAXA JÁ CRIADA, PODE SER:DEM,DE2,DE3,DE4,DE5,DE6,DE7,DE8,DE9

	BEGIN
		INSERT INTO CTA_CTE_HOU_IMP_MAR	
		Select 
			HOU.Num_Proc_HIM,@CD_TP_TX,'C','Excel Int',convert(varchar,getdate(),103),'REL',@vlr_org_him,
			convert(varchar,getdate()+20,103),Cd_CONSIG_HIM,'N','N','S','N','N','N',NULL,
			NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
		From 
			llp_IMP_mar LLP
			Join House_IMP_Mar HOU on llp.num_proc_lIm=hou.num_proc_hIm
			Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx=@CD_TP_TX and dc_him='C'
		where		
			HOU.Num_Proc_HIM = @num_proc
			and cta.num_proc_him is null 
	END
	
	
	
	Begin
		Insert into Log_Cta_Cte		
			Select 
				getdate(), @cd_usuario, 'I',HOU.Num_Proc_HIM,@CD_TP_TX,
				'C','Excel Int',convert(varchar,getdate(),103),'REL',@vlr_org_him,
				convert(varchar,getdate()+20,103),Cd_CONSIG_HIM,
				'N','N','S','N','N','N',
				0,NULL,0,NULL
			From 
				llp_IMP_mar LLP
				Join House_IMP_Mar HOU on llp.num_proc_lIm=hou.num_proc_hIm
				Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx=@CD_TP_TX and dc_him='C'
			where		
				HOU.Num_Proc_HIM = @num_proc		
	End
	
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION



	
		--(Data_CC,Cd_Usuario,Tp_Oper_CC,Num_Proc_CC,Cd_Tp_Tx,
		--DC_CC,Org_Ins,Dt_Ins,Cd_Tp_Moeda,Vlr_Org,
		--Dt_Prev_Pgto,Cd_Cred_Dev,
		--Desp_Org_Dst,CPMF,Comp_RP,Comp_DN,Comp_CN,Comp_CPA,
		--Contab,Vlr_Contab,Contab_Ant,Cointab_Mes_Ano)
GO
