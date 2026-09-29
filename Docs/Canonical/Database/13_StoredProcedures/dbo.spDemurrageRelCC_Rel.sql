SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spDemurrageRelCC_Rel]--'2011-05-01','2011-08-01','OXT'
	@Dt_Inicial	datetime,
	@Dt_Final	datetime,
	@grupo	varchar(3)
as
	select 
		HIM.num_proc_him	Job,
		PO.numero_po_him		PO,
		CP.numero_po_him		CustomerPO,
		CS.apelido			Consignee,
		HM.mawb_him			BL,		
		num_cont_im			Container,
		lim.ata_lim			ATA,
		dbo.[fBusca_Tarefa](LIM.num_proc_lim,7) docs,					
		dt_vcto_devol_im	dt_vcto, 
		dt_devol_im			dt_devol,
		TC.nome_tp_cont		tipo ,		
		ARM.nome_armador armador
	from container_mas_imp_mar MIM
	join container_hou_imp_mar HIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM and MIM.Item_Cont_IM = HIM.Item_Cont_IM   
	left join po_him PO on PO.num_proc_him = HIM.num_proc_him and po.id_dc = 1
	left join po_him CP on CP.num_proc_him = HIM.num_proc_him and cp.id_dc = 9
	left join tipo_container TC on TC.cd_tp_cont = MIM.cd_tp_cont
	left join llp_imp_mar LIM on LIM.num_proc_lim = HIM.num_proc_him
	left join house_imp_mar HM on HM.num_proc_him = LIM.num_proc_lim
	left join Pessoa CS	on CS.cd_pes = HM.cd_consig_him
	left join job_imp_mar JIM on JIM.num_proc_him = LIM.num_proc_lim
	left join armador ARM on arm.cd_armador = Jim.cd_armador

	where right(left(HIM.num_proc_him,5),3) = @grupo and
	MIM.cd_tp_cont not in ('LCL','LCM')	
	and lim.atd_lim between @Dt_Inicial and @Dt_Final

order by
	HIM.num_proc_him







GO
