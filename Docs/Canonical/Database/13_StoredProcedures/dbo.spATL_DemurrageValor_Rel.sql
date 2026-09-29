SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_DemurrageValor_Rel]--'GRUPO FREIGHT FORWAD','2013-06-01','2013-09-19'
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

If @Grupo = 'ATL'
	Begin
		select 
			HIM.num_proc_him	[Job],
			PO.numero_po_him	[PO],
			CS.apelido			[Consignee],		
			HM.mawb_him			[BL Number (MBL)],
			HM.hawb_him			[BL Number (HBL)],
			ARM.nome_armador	[Carrier],		
			num_cont_im			[Container],
			lim.ata_lim			[ATA Date],
			([dbo].[fBusca_CaixaMASTaxaVlr](HIM.num_proc_mim,'Demurrage%','D') / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Paga (Mbl)],
			
			([dbo].[fBusca_CaixaMASTaxaVlr](HIM.num_proc_mim,'Desconto de Demurrage%','C')) [Desconto de Demurrage (Mbl)],

			(([dbo].[fBusca_CaixaMASTaxaVlr](HIM.num_proc_mim,'Demurrage%','D') - [dbo].[fBusca_CaixaMASTaxaVlr](HIM.num_proc_mim,'Desconto de Demurrage%','C ')) / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Paga - Desconto (Mbl)],

			([dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','C') / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Recebida (HBL)],

			([dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Desconto de Demurrage%','D')) [Desconto de Demurrage (HBL)] ,
			
			(([dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','C') - [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Desconto de Demurrage%','D')) / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Recebida - Desconto(HBL)]
			--alterado pra C
		from 
			container_mas_imp_mar MIM
			join container_hou_imp_mar HIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM and MIM.Item_Cont_IM = HIM.Item_Cont_IM   
			left join po_him PO on PO.num_proc_him = HIM.num_proc_him and po.id_dc = 1
			left join po_him CP on CP.num_proc_him = HIM.num_proc_him and cp.id_dc = 9
			left join tipo_container TC on TC.cd_tp_cont = MIM.cd_tp_cont
			left join llp_imp_mar LIM on LIM.num_proc_lim = HIM.num_proc_him
			left join house_imp_mar HM on HM.num_proc_him = LIM.num_proc_lim
			left join Pessoa CS	on CS.cd_pes = HM.cd_consig_him
			left join job_imp_mar JIM on JIM.num_proc_him = LIM.num_proc_lim
			left join armador ARM on arm.cd_armador = Jim.cd_armador		
		where 
--			him.num_proc_him = 'IMATL201201113BR' and
--			right(left(HIM.num_proc_him,5),3) = @grupo and
			HIM.Num_proc_MIM <> 'JOB' and
			MIM.cd_tp_cont not in ('LCL','LCM')	
			and lim.atd_lim between @DtInicial and @DtFinal
			AND ISNULL(LIM.ID_STATUS,0) <> 9
		order by
			HIM.num_proc_him
	END

else
	BEGIN
		select 
			HIM.num_proc_him	[Job],
			PO.numero_po_him	[PO],
			CS.apelido			[Consignee],		
			HM.mawb_him			[BL Number (MBL)],
			HM.hawb_him			[BL Number (HBL)],
			ARM.nome_armador	[Carrier],		
			num_cont_im			[Container],
			lim.ata_lim			[ATA Date],
			([dbo].[fBusca_CaixaMASTaxaVlr](HIM.num_proc_mim,'Demurrage%','D') / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Paga (Mbl)],			
			([dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','C') / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Recebida (HBL)]
			--alterado pra C
		from 
			container_mas_imp_mar MIM
			join container_hou_imp_mar HIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM and MIM.Item_Cont_IM = HIM.Item_Cont_IM   
			left join po_him PO on PO.num_proc_him = HIM.num_proc_him and po.id_dc = 1
			left join po_him CP on CP.num_proc_him = HIM.num_proc_him and cp.id_dc = 9
			left join tipo_container TC on TC.cd_tp_cont = MIM.cd_tp_cont
			left join llp_imp_mar LIM on LIM.num_proc_lim = HIM.num_proc_him
			left join house_imp_mar HM on HM.num_proc_him = LIM.num_proc_lim
			left join Pessoa CS	on CS.cd_pes = HM.cd_consig_him
			left join job_imp_mar JIM on JIM.num_proc_him = LIM.num_proc_lim
			left join armador ARM on arm.cd_armador = Jim.cd_armador		
		where 
			right(left(HIM.num_proc_him,5),3) = @grupo and
			MIM.cd_tp_cont not in ('LCL','LCM')	
			and lim.atd_lim between @DtInicial and @DtFinal
			AND ISNULL(LIM.ID_STATUS,0) <> 9
		order by
			HIM.num_proc_him
	END







GO
