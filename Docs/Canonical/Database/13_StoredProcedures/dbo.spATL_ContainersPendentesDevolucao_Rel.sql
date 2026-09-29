SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--spATL_ContainersPendentesDevolucao_Rel 'GRUPO FREIGHT FORWAD','2011-01-01','2011-11-30',''


CREATE PROCEDURE [dbo].[spATL_ContainersPendentesDevolucao_Rel]
	@Grupo varchar(20),
	@Dt_Inicial	datetime,
	@Dt_Final	datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	select 
		HOU.Num_Proc_HIM								[Ref. BDP],
		CSN.Apelido										[Consignee],
		HOU.HAWB_HIM									[BL Number],
		PO1.numero_po_him								[PO Number],
		Org.Nome_Local									[Origin],
		AD.Nome_Armador									[Carrier],
		Navio_HIM										[Vessel],
		CMIM.Num_Cont_IM + '   ' + CMIM.cd_tp_Cont		[Container],
		null											[(Dev.)],
		TERM.Nome_terminal								[Terminal],
		Transp.Apelido									[Transportadora],
		DI.Numero_PO_Him								[DI Number],
		DI.data_po_him									[DI Date]
	from
		house_imp_mar HOU with(nolock)
		Join LLP_Imp_Mar LLP with(nolock) on LLP.num_proc_LIM=hou.num_proc_HIM
		Join Job_Imp_mar JOB with(nolock) on JOB.num_proc_HIM=hou.num_proc_HIM
		Join container_hou_imp_mar CHOU with(nolock) on CHOU.num_proc_him=HOU.num_proc_him
		join container_mas_imp_mar CMIM with(nolock) on CMIM.Num_Proc_MIM = CHOU.Num_Proc_MIM and CMIM.Item_Cont_IM=CHOU.Item_cont_im
		Join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIM
		left Join Localidade Org with(nolock) on hou.cd_org_HIM=Org.cd_local
		left join Armador AD with(nolock) on AD.cd_Armador = JOB.cd_armador
		Left Join Terminal TERM with(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join Pessoa Transp with(nolock) on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Join PO_HIM DI with(nolock) on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Left Join PO_HIM PO1 with(nolock) on PO1.Num_Proc_Him=hou.num_proc_him and PO1.id_dc=1
	where
		substring(HOU.num_proc_him,3,3) = @Grupo and LLP.ATA_LIM between @Dt_Inicial and @Dt_Final
		and (CMIM.Dt_Devol_IM is null or CMIM.Dt_Devol_IM='')
	group by
		hou.Num_Proc_Him,
		CSN.Apelido,
		HOU.HAWB_HIM,
		PO1.numero_po_him,
		Org.Nome_Local,
		AD.Nome_Armador,
		Navio_HIM,
		TERM.Nome_terminal,
		DI.Numero_PO_Him,DI.data_po_him,
		CMIM.Dt_Devol_IM,
		CMIM.Num_Cont_IM,
		CMIM.cd_tp_Cont,
		Transp.Apelido


GO
