SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_ATLSOLAS_Trigger_Sel]--'EMCBT201606001BR'
(
	@Num_Proc varchar(16)
)
as

select	
	isnull(Armador.Nome_Armador,'Not Informed')		Carrier,
	isnull(Armador.SCAC	,'Not Informed')			SCAC,	
	isnull(HOU.Booking_Number,'Not Informed')		[Booking Number],
	--dbo.fbusca_docs_po_modal(CH.Num_Proc_HEM,'01')	Shipper_Reference,
	--CH.Num_Proc_HEM									Forwarder_Reference,
	--HOU.Vessel										Vessel,
	--HOU.Voyage										Voyage,
	--Orig.Nome_Local 								Loading,
	--Destin.Nome_Local 								Delivery,
	--Planta.nome_local 								Planta,
	--DstFinal.Nome_Local 							DstFinal,	
	isnull(CM.num_cont_em,'Not Informed')			Container,	
	isnull(Convert(varchar(25),CAI.Peso_Bruto_EM_VGM),'Not Informed') [Verified Gross Mass],
	isnull(Convert(varchar(25),CAI.UOM_VGM),'Not Informed')			 [UOM VGM],
	isnull(CAI.Nome_Responsavel_VGM	,'Not Informed')				[Responsible Party],
	isnull(Convert(varchar(12),CAI.Dt_Envio_VGM,103),'Not Informed')	[Verification Date],
	isnull(Convert(varchar(25),CAI.Metodo_VGM),'Not Informed')		Method	
from Container_Hou_Exp_mar CH			with(nolock)
	join Container_Mas_Exp_Mar CM		with(nolock) on CH.Num_Proc_MEM = CM.Num_Proc_MEM and CH.Item_Cont_EM = CM.Item_Cont_EM
	left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc and CAI.num_cont = replace(CM.num_cont_em,'-','') and ativo=1	
	Left Outer Join vwHouse_Exp	HOU		with(nolock) on CH.Num_Proc_HEM = HOU.Num_Proc
	Left Outer Join Armador	Armador		with(nolock) on HOU.cd_armador = Armador.cd_Armador
	Left Outer join Pessoa P			with(nolock) on P.Cd_Pes = HOU.Cd_Export
	Left Outer join Tipo_Carga C		with(nolock) on c.Cd_Tp_Carga = HOU.Cd_Tp_Carga
	Left Outer Join Localidade Orig		with(nolock) on HOU.Cd_Org = Orig.Cd_Local 
	Left Outer Join Localidade Destin	with(nolock) on HOU.Cd_Dst = Destin.Cd_Local
	Left Outer Join Localidade Planta	with(nolock) on HOU.cd_Planta = Planta.cd_local
	Left Outer Join Localidade DstFinal with(nolock) on HOU.cd_dstfinal = Dstfinal.cd_local 	
where 
	CH.Num_Proc_HEM = @Num_Proc
	and Armador.gix_armador = 1
	
--select 
--	Num_Lacre_EM [Seal],
--	Peso_Bruto_EM [Gross Weight],
--	VolumeM3 [Volume],Tara_EM [Tare],CAI.Peso_Bruto_EM_VGM [Gross Weight VGM],LEM.DL_VGM [DeadLine VGM]  ,CAI.UOM_VGM [UOM VGM],CAI.Dt_Envio_VGM [Reported VGM], CAI.Nome_Responsavel_VGM [AUTORIZED PERSON] from Container_Hou_Exp_mar CH with(nolock)
--join Container_Mas_Exp_Mar CM with(nolock) on CH.Num_Proc_MEM = CM.Num_Proc_MEM and CH.Item_Cont_EM = CM.Item_Cont_EM
--left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc
--join vwHouse_Exp LEM with(nolock) on CAI.num_proc = LEM.Num_Proc
--where CH.Num_Proc_HEM = @Num_Proc
GO
