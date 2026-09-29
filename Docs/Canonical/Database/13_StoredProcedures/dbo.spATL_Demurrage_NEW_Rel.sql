SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Demurrage_NEW_Rel 'GRUPO LM WIND POWER ','2015-01-01','2015-05-31'
--incluida a clausula pra oxiteno conforme solicitado pela Camila Pereira - 24-2-2012
--04/05/2012 - Incluido calculo estimado de demurrage - Anderson Oliveira
	--select datediff(day,CONVERT(datetime,'17/01/2015',103),getdate())
	
CREATE Procedure [dbo].[spATL_Demurrage_NEW_Rel]
	@Grupo varchar(50),
	@DtInicial datetime,
	@DtFinal datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
	update Container_Mas_Imp_Mar set Dt_Devol_IM = null where Dt_Devol_IM=''
If @Grupo = 'ATL'
	Begin
		select 
			HIM.num_proc_him	[Job],
			PO.numero_po_him	[PO],
			CS.apelido			[Consignee],
			ORG.nome_local		[Origem],
			DST.nome_local		[Destino],
			TE.nome_terminal	[Terminal],
			HM.mawb_him			[BL Number],
			ARM.nome_armador	[Carrier],		
			num_cont_im			[Container],
			lim.ata_lim			[ATA Date],
			--isnull(ARM.FreeTime,10) [Free-Time],
			TDE.Dias [Free-Time],
			--(case when left(HIM.num_proc_him,5) <> 'IMOXT' then LIM.ata_lim + isnull(ARM.freetime,10)
			--	when left(HIM.num_proc_him,5) = 'IMOXT' and dt_vcto_devol_im = '' then null
			--		else convert(datetime,dt_vcto_devol_im,103) end) [Exp. Del. Date],	
			(case when left(HIM.num_proc_him,5) <> 'IMOXT' then LIM.ata_lim + TDE.Dias
				when left(HIM.num_proc_him,5) = 'IMOXT' and dt_vcto_devol_im = '' then null
					else convert(datetime,dt_vcto_devol_im,103) end) [Exp. Del. Date],
			dt_devol_im			[Return Date],
			dbo.[fBusca_Tarefa](LIM.num_proc_lim,7) [Docs to Transp. date],
			TC.nome_tp_cont		[Type],
			([dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D') / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Paga],
			(
				case 
						When left(MIM.cd_tp_cont,2)='20' and [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D')=0 then 30*(cast(((getdate()-ATA_LIM)) as int)- isnull(ARM.freetime,10))
						when left(MIM.cd_tp_cont,2)='40' and [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D')=0 then 50*(cast(((getdate()-ATA_LIM)) as int)- isnull(ARM.freetime,10))
						else 0
				End
			) [Estimated Costs],	
			
			(
				case 
						When [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D')=0 then [dbo].[fBusca_Valor_DemurageBDP](MIM.cd_tp_cont,datediff(day,ATA_Lim,getdate())- TDE.Dias)
						else 0
				End
			) [Estimated Costs]	,
			datediff(day,ATA_Lim,getdate()- TDE.Dias) [Days]			
			
	from 
			container_mas_imp_mar MIM with (nolock)
			join container_hou_imp_mar HIM with(nolock)on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM and MIM.Item_Cont_IM = HIM.Item_Cont_IM   
			left join po_him PO with (nolock) on PO.num_proc_him = HIM.num_proc_him and po.id_dc = 1
			left join po_him CP with (nolock) on CP.num_proc_him = HIM.num_proc_him and cp.id_dc = 9
			left join tipo_container TC with (nolock) on TC.cd_tp_cont = MIM.cd_tp_cont
			left join llp_imp_mar LIM with (nolock) on LIM.num_proc_lim = HIM.num_proc_him
			left join house_imp_mar HM with (nolock) on HM.num_proc_him = LIM.num_proc_lim
			left join Pessoa CS with (nolock)	on CS.cd_pes = HM.cd_consig_him
			left join job_imp_mar JIM with (nolock) on JIM.num_proc_him = LIM.num_proc_lim
			left join armador ARM with (nolock) on arm.cd_armador = Jim.cd_armador
			left join localidade ORG with(nolock) on ORG.cd_local = HM.cd_org_him
			left join localidade DST with(nolock) on DST.cd_local = HM.cd_dst_him
			left join terminal TE with(nolock) on TE.cd_terminal = LIM.cd_terminal	
			Left Outer Join Taxa_Demurrage_BDP	TDE	with(nolock) on TDE.cd_tp_cont = MIM.cd_tp_cont and TDE.Periodo = 0		
		where 
			--right(left(HIM.num_proc_him,5),3) = @grupo and
			HIM.Num_proc_MIM <> 'JOB' and
			MIM.cd_tp_cont not in ('LCL','LCM')	
			and lim.atd_lim between @DtInicial and @DtFinal
			AND ISNULL(LIM.ID_STATUS,0) <> 9
			and (
					
				--convert(datetime,dt_devol_im,105)-ATA_LIM > isnull(ARM.freetime,10)
				convert(datetime,dt_devol_im,105)-ATA_LIM > TDE.Dias				
				OR
				dt_devol_im is null
				or
				dt_devol_im=''
			)
		order by
			HIM.num_proc_him
	End
Else
	Begin
			select 
			HIM.num_proc_him	[Job],
			PO.numero_po_him	[PO],
			CS.apelido			[Consignee],
			ORG.nome_local		[Origem],
			DST.nome_local		[Destino],
			TE.nome_terminal	[Terminal],
			HM.HAWB_HIM			[HBL Number],
			--HM.MAWB_HIM			[MBL Number],
			ARM.nome_armador	[Carrier],		
			num_cont_im			[Container],
			lim.ata_lim			[ATA Date],
			--isnull(ARM.FreeTime,10) [Free-Time],
			TDE.Dias [Free-Time],
			--(case when left(HIM.num_proc_him,5) <> 'IMOXT' then LIM.ata_lim + isnull(ARM.freetime,10)
			--	when left(HIM.num_proc_him,5) = 'IMOXT' and dt_vcto_devol_im = '' then null
			--		else convert(datetime,dt_vcto_devol_im,103) end) [Exp. Del. Date],
			(case when left(HIM.num_proc_him,5) <> 'IMOXT' then LIM.ata_lim + TDE.Dias
				when left(HIM.num_proc_him,5) = 'IMOXT' and dt_vcto_devol_im = '' then null
					else convert(datetime,dt_vcto_devol_im,103) end) [Exp. Del. Date],			
			--LIM.ata_lim + isnull(ARM.freetime,10) [Exp. Del. Date],
			dt_devol_im			[Return Date],
			dbo.[fBusca_Tarefa](LIM.num_proc_lim,7) [Docs to Transp. date],
			TC.nome_tp_cont		[Type],
			([dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D') / [dbo].[Qty_Container](HIM.num_proc_him))[Valor da Demurrage Paga],
			(
				case 
						When left(MIM.cd_tp_cont,2)='20' and [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D')=0 then 30*(cast(((getdate()-ATA_LIM)) as int)- isnull(ARM.freetime,10))
						when left(MIM.cd_tp_cont,2)='40' and [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D')=0 then 50*(cast(((getdate()-ATA_LIM)) as int)- isnull(ARM.freetime,10))
						else 0
				End
			) [Estimated Costs]	,				
			
			(
				case 
						When [dbo].[fBusca_CaixaTaxaVlr](HIM.num_proc_him,'Demurrage%','D')=0 then [dbo].[fBusca_Valor_DemurageBDP](MIM.cd_tp_cont,datediff(day,ATA_Lim,getdate())- TDE.Dias)
						else 0
				End
			) [Estimated Costs]	,			
			--(cast(((getdate()-ATA_LIM)) as int)- isnull(ARM.freetime,10)) [Days]
			datediff(day,ATA_Lim,getdate()- TDE.Dias) [Days]
	from 
			container_mas_imp_mar MIM with (nolock)
			join container_hou_imp_mar HIM with(nolock)on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM and MIM.Item_Cont_IM = HIM.Item_Cont_IM   
			left join po_him PO with (nolock) on PO.num_proc_him = HIM.num_proc_him and po.id_dc = 1
			left join po_him CP with (nolock) on CP.num_proc_him = HIM.num_proc_him and cp.id_dc = 9
			left join tipo_container TC with (nolock) on TC.cd_tp_cont = MIM.cd_tp_cont
			left join llp_imp_mar LIM with (nolock) on LIM.num_proc_lim = HIM.num_proc_him
			left join house_imp_mar HM with (nolock) on HM.num_proc_him = LIM.num_proc_lim
			left join Pessoa CS with (nolock)	on CS.cd_pes = HM.cd_consig_him
			left join job_imp_mar JIM with (nolock) on JIM.num_proc_him = LIM.num_proc_lim
			left join armador ARM with (nolock) on arm.cd_armador = Jim.cd_armador
			left join localidade ORG with(nolock) on ORG.cd_local = HM.cd_org_him
			left join localidade DST with(nolock) on DST.cd_local = HM.cd_dst_him
			left join terminal TE with(nolock) on TE.cd_terminal = LIM.cd_terminal
			Left Outer Join Taxa_Demurrage_BDP	TDE	with(nolock) on TDE.cd_tp_cont = MIM.cd_tp_cont and TDE.Periodo = 0		
		where 
			right(left(HIM.num_proc_him,5),3) = @grupo and
			MIM.cd_tp_cont not in ('LCL','LCM')	
			and lim.atd_lim between @DtInicial and @DtFinal
			AND ISNULL(LIM.ID_STATUS,0) <> 9
			and (
					
				--convert(datetime,dt_devol_im,105)-ATA_LIM > isnull(ARM.freetime,10)
				convert(datetime,dt_devol_im,105)-ATA_LIM > TDE.Dias
				OR
				dt_devol_im is null
				or
				dt_devol_im=''
			)
		order by
			HIM.num_proc_him
	End
	
	
	--select * from Tipo_Container
	--Taxa_Demurrage_BDP
	--select * from Taxa_Demurrage_BDP 
	
	--select * from Container_Mas_Imp_Mar where Num_Proc_MIM = 'IMSAP201412001' and Item_Cont_IM = 1
	--select * from Container_Mas_Imp_Mar where Num_Proc_MIM = 'IMSAP201412001' and Item_Cont_IM = 2
	--select * from Container_Hou_Imp_Mar where Num_Proc_HIM = 'IMLMW201412001BR'
	
	--select datediff(day,ATA_Lim,getdate()),ATA_Lim from llp_imp_mar where Num_Proc_Lim = 'IMLMW201412001BR'
	
	--40H
	
	--Declare @dias as int
	--Declare @cd_tp_cont as varchar(3)
	--Declare @diasTaxa as int
	--Declare @Taxa as float
	
	--set @dias = (select datediff(day,ATA_Lim,getdate()) from llp_imp_mar 
	--	where Num_Proc_Lim = 'IMLMW201412001BR')		
	--print @dias
	
	--set @cd_tp_cont = (select Cd_Tp_Cont from Container_Mas_Imp_Mar 
	--	where Num_Proc_MIM = 'IMSAP201412001' and Item_Cont_IM = 2)		
	--print @cd_tp_cont
		
	--set @diasTaxa = (select dias from Taxa_Demurrage_BDP TDE where cd_tp_cont =@cd_tp_cont and Periodo = 1)	
	--print @diasTaxa
	
	--set @diasTaxa = (select (case when @diasTaxa <= @dias then Taxa else 0 end) from Taxa_Demurrage_BDP TDE 
	--	where cd_tp_cont =@cd_tp_cont and Periodo = 1)
	--print @diasTaxa
	
	--if @Taxa = 0
	--	begin
	--		set @diasTaxa = @diasTaxa + (select dias from Taxa_Demurrage_BDP TDE 
	--				where cd_tp_cont =@cd_tp_cont and Periodo = 2)
	--		set @Taxa = (select (case when @diasTaxa  <= @dias then Taxa else 0 end) from Taxa_Demurrage_BDP TDE 
	--				where cd_tp_cont =@cd_tp_cont and Periodo = 2)
	--	end
	--else
	--	set @Taxa = (select Taxa from Taxa_Demurrage_BDP TDE where cd_tp_cont =@cd_tp_cont and Periodo = 3)
		
	--print @Taxa * @dias
GO
