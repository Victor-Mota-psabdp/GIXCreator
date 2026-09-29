SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Container_Additional_Info where num_proc like 'EMATL%'
--Precisa atualizar a view [vwHouse_Exp] 
CREATE procedure [dbo].[spATL_SOLAS_VGM_REL] --'EMFMC201603005BR',''
(
	@Num_Proc varchar(16),
	@USuario varchar(250)
)
as

select	
	Armador.Nome_Armador 							Carrier,
	HOU.Booking_Number								Booking_Number,
	dbo.fbusca_docs_po_modal(CH.Num_Proc_HEM,'01')	Shipper_Reference,
	CH.Num_Proc_HEM									Forwarder_Reference,
	HOU.Vessel										Vessel,
	HOU.Viagem										Voyage,
	Orig.Nome_Local 								Loading,
	Destin.Nome_Local 								Delivery,
	Planta.nome_local 								Planta,
	DstFinal.Nome_Local 							DstFinal,	
	CM.num_cont_em									Container,	
	CAI.Peso_Bruto_EM_VGM							Verified_Gross_Mass,
	CAI.UOM_VGM										UOM_VGM,
	CAI.Nome_Responsavel_VGM						Responsible_Party,
	REPLACE(CONVERT(NVARCHAR,CAI.Dt_Envio_VGM, 106), ' ', '-') [Verification_Date],
	CAI.Metodo_VGM									Method		
from Container_Hou_Exp_mar CH with(nolock)
	join Container_Mas_Exp_Mar CM with(nolock) on CH.Num_Proc_MEM = CM.Num_Proc_MEM and CH.Item_Cont_EM = CM.Item_Cont_EM
	left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc and CAI.num_cont = replace(CM.num_cont_em,'-','') and ativo=1	
	Left Outer Join vwHouse_Exp	HOU with(nolock)	on CH.Num_Proc_HEM = HOU.Num_Proc
	Left Outer Join Armador	Armador with(nolock)	on HOU.cd_armador = Armador.cd_Armador
	Left Outer join Pessoa P with(nolock) on P.Cd_Pes = HOU.Cd_Export
	Left Outer join Tipo_Carga C with(nolock) on c.Cd_Tp_Carga = HOU.Cd_Tp_Carga
	Left Outer Join Localidade	Orig with(nolock) on HOU.Cd_Org = Orig.Cd_Local 
	Left Outer Join Localidade	Destin with(nolock) on HOU.Cd_Dst = Destin.Cd_Local
	Left Outer Join Localidade	Planta with(nolock)	on HOU.cd_Planta = Planta.cd_local
	Left Outer Join Localidade	DstFinal with(nolock) on HOU.cd_dstfinal = Dstfinal.cd_local 	
where 
	CH.Num_Proc_HEM = @Num_Proc
GO
