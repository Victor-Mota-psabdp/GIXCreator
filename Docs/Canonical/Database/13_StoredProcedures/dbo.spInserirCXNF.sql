SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  Procedure [dbo].[spInserirCXNF]
(
	@Data	varchar(10),
	@num_proc	varchar(16),
	@num_lcto	varchar(12)
)
as
	begin
		Insert into Caixa_hou_exp_aer

		select @Num_Proc,cd_tp_Tx,Dc_hea,@Num_Lcto,Vlr_Org_Hea,@Data,'OFC',1,Vlr_org_hea,@Data,null,null,null,'',null from cta_cte_hou_exp_aer cta
		where num_proc_hea=@num_proc and ((cta.cd_tp_Tx in ('XBA') and dc_hea='C') )
	end

	begin
		Insert into Caixa_hou_imp_aer

		select @Num_Proc,cd_tp_Tx,Dc_hia,@Num_Lcto,Vlr_Org_hia,@Data,'OFC',1,Vlr_org_hia,@Data,null,null,null,'',null from cta_cte_hou_imp_aer cta
		where num_proc_hia=@num_proc and ((cta.cd_tp_Tx in ('XBA') and dc_hia='C') )
	end

	begin
		Insert into Caixa_hou_exp_mar

		select @Num_Proc,cd_tp_Tx,Dc_hem,@Num_Lcto,Vlr_Org_hem,@Data,'OFC',1,Vlr_org_hem,@Data,null,null,null,'',null from cta_cte_hou_exp_mar cta
		where num_proc_hem=@num_proc and ((cta.cd_tp_Tx in ('XBA') and dc_hem='C') )
	

end

	begin
		Insert into Caixa_hou_imp_mar

		select @Num_Proc,cd_tp_Tx,Dc_him,@Num_Lcto,Vlr_Org_him,@Data,'OFC',1,Vlr_org_him,@Data,null,null,null,'',null from cta_cte_hou_imp_mar cta
		where num_proc_him=@num_proc and ((cta.cd_tp_Tx in ('XBA') and dc_him='C') )
	end

	begin
		Insert into Caixa_hou_exp_out

		select @Num_Proc,cd_tp_Tx,Dc_heo,@Num_Lcto,Vlr_Org_heo,@Data,'OFC',1,Vlr_org_heo,@Data,null,null,null,'',null from cta_cte_hou_exp_out cta
		where num_proc_heo=@num_proc and ((cta.cd_tp_Tx in ('XBA') and dc_heo='C') )
	end

	begin
		Insert into Caixa_hou_imp_out

		select @Num_Proc,cd_tp_Tx,Dc_hio,@Num_Lcto,Vlr_Org_hio,@Data,'OFC',1,Vlr_org_hio,@Data,null,null,null,'',null from cta_cte_hou_imp_out cta
		where num_proc_hio=@num_proc and ((cta.cd_tp_Tx in ('XBA') and dc_hio='C') )
	end


GO
