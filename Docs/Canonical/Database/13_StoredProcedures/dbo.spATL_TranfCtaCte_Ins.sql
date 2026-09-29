SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TranfCtaCte_Ins](
@Num_ProcTemp varchar(16),
@Num_ProcReal varchar(16),
@Cd_Tp_Tx_O varchar(3),
@Cd_Tp_Tx_N varchar(3),
@DC char(1),
@Cd_Usuario varchar(10)
)
as

--Begin Transaction
if left(@Num_ProcTemp,2) = 'IM'
begin
	if NOT exists (select num_proc_him from Cta_Cte_Hou_Imp_Mar where Num_Proc_HIM = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_HIM in (select(case when @DC = 'C' then 'D' else 'C' end)))
	Begin
	insert Cta_Cte_Hou_Imp_Mar
	Select 
		Num_Proc_HIM,Cd_Tp_Tx,(case when @DC = 'C' then 'D' else 'C' end) ,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_HIM,convert(varchar,getdate()+20,103),Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,
		Comp_RP_HIM,Comp_DN_HIM,Comp_CN_HIM,Comp_CPA_HIM,Num_DCN_HIM,Dt_Ctb_CC_HIM,
		Num_NF_HIM,Ref_Acesso_NF_HIM,Vlr_Pgto_NF_HIM,Par_NF_HIM,Comp_Job_HIM,Contab,
		Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp from Cta_Cte_Hou_Imp_Mar
	where Num_Proc_HIM = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_HIM = @DC
	union all
	select 							
		@Num_ProcReal,@Cd_Tp_Tx_N,DC_HIM,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_HIM,convert(varchar,getdate()+20,103),Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,
		Comp_RP_HIM,Comp_DN_HIM,Comp_CN_HIM,Comp_CPA_HIM,Num_DCN_HIM,Dt_Ctb_CC_HIM,
		Num_NF_HIM,Ref_Acesso_NF_HIM,Vlr_Pgto_NF_HIM,Par_NF_HIM,Comp_Job_HIM,Contab,
		Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp from Cta_Cte_Hou_Imp_Mar
	where Num_Proc_HIM = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_HIM = @DC

	insert  Log_Cta_Cte
	Select 
		getdate(),@Cd_Usuario,'I',Num_Proc_HIM,Cd_Tp_Tx,(case when @DC = 'C' then 'D' else 'C' end) ,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_HIM,convert(varchar,getdate()+20,103),Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,
		Comp_RP_HIM,Comp_DN_HIM,Comp_CN_HIM,Comp_CPA_HIM,Contab,
		Vlr_Contab,Contab_Ant,Contab_Mes_Ano from Cta_Cte_Hou_Imp_Mar
	where Num_Proc_HIM = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_HIM = @DC
	union all
	select 							
		getdate(),@Cd_Usuario,'I', @Num_ProcReal,@Cd_Tp_Tx_N,DC_HIM,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_HIM,convert(varchar,getdate()+20,103),Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,
		Comp_RP_HIM,Comp_DN_HIM,Comp_CN_HIM,Comp_CPA_HIM,Contab,
		Vlr_Contab,Contab_Ant,Contab_Mes_Ano from Cta_Cte_Hou_Imp_Mar
	where Num_Proc_HIM = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_HIM = @DC
	--delete Cta_Cte_Hou_Imp_Mar
	--where Num_Proc_HIM = 'IMLVS201501001BR' and Cd_Tp_Tx = 'XAU' and DC_HIM = 'C'
	End
end
if left(@Num_ProcTemp,2) = 'IA'
begin
	if NOT exists (select num_proc_hia from Cta_Cte_Hou_Imp_aer where Num_Proc_hia = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_hia in (select(case when @DC = 'C' then 'D' else 'C' end)))
	Begin
	insert Cta_Cte_Hou_Imp_aer
	Select 
		Num_Proc_hia,Cd_Tp_Tx,(case when @DC = 'C' then 'D' else 'C' end) ,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_hia,convert(varchar,getdate()+20,103),Cd_Cred_Dev_hia,Desp_Org_hia,CPMF_hia,
		Comp_RP_hia,Comp_DN_hia,Comp_CN_hia,Comp_CPA_hia,Num_DCN_hia,Dt_Ctb_CC_hia,
		Num_NF_hia,Ref_Acesso_NF_hia,Vlr_Pgto_NF_hia,Par_NF_hia,Comp_Job_hia,Contab,
		Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp from Cta_Cte_Hou_Imp_aer
	where Num_Proc_hia = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_hia = @DC
	union all
	select 							
		@Num_ProcReal,@Cd_Tp_Tx_N,DC_hia,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_hia,convert(varchar,getdate()+20,103),Cd_Cred_Dev_hia,Desp_Org_hia,CPMF_hia,
		Comp_RP_hia,Comp_DN_hia,Comp_CN_hia,Comp_CPA_hia,Num_DCN_hia,Dt_Ctb_CC_hia,
		Num_NF_hia,Ref_Acesso_NF_hia,Vlr_Pgto_NF_hia,Par_NF_hia,Comp_Job_hia,Contab,
		Vlr_Contab,Contab_Ant,Vlr_Contab_Ant,Contab_Mes_Ano,Val_Con_Comp from Cta_Cte_Hou_Imp_aer
	where Num_Proc_hia = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_hia = @DC

	insert  Log_Cta_Cte
	Select 
		getdate(),@Cd_Usuario,'I',Num_Proc_hia,Cd_Tp_Tx,(case when @DC = 'C' then 'D' else 'C' end) ,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_hia,convert(varchar,getdate()+20,103),Cd_Cred_Dev_hia,Desp_Org_hia,CPMF_hia,
		Comp_RP_hia,Comp_DN_hia,Comp_CN_hia,Comp_CPA_hia,Contab,
		Vlr_Contab,Contab_Ant,Contab_Mes_Ano from Cta_Cte_Hou_Imp_aer
	where Num_Proc_hia = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_hia = @DC
	union all
	select 							
		getdate(),@Cd_Usuario,'I', @Num_ProcReal,@Cd_Tp_Tx_N,DC_hia,'Transf.',convert(varchar,getdate(),103),Cd_Tp_Moeda,
		Vlr_Org_hia,convert(varchar,getdate()+20,103),Cd_Cred_Dev_hia,Desp_Org_hia,CPMF_hia,
		Comp_RP_hia,Comp_DN_hia,Comp_CN_hia,Comp_CPA_hia,Contab,
		Vlr_Contab,Contab_Ant,Contab_Mes_Ano from Cta_Cte_Hou_Imp_aer
	where Num_Proc_hia = @Num_ProcTemp and Cd_Tp_Tx = @Cd_Tp_Tx_O and DC_hia = @DC
	--delete Cta_Cte_Hou_Imp_aer
	--where Num_Proc_hia = 'IMLVS201501001BR' and Cd_Tp_Tx = 'XAU' and DC_hia = 'C'
	End
end


--		IF @@Error <> 0
--			BEGIN
--				ROLLBACK TRANSACTION
--				RETURN -1
--			END
--Commit Transaction 


--select * from Tipo_Taxa
--where Nome_Tp_Tx like 'LI CHB%' and Desat_Tx = 'N' order by Nome_Tp_Tx

--select * from LOG_Tipo_Taxa
--where Nome_Tp_Tx like 'LI CHB%' and Desat_Tx = 'N' order by Nome_Tp_Tx

--select * from 



GO
