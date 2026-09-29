SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPreAviso_Imp] --'IMACO20090700101'
(
@Num_proc varchar(16)
)
AS
select 

		LLP.Num_proc_lim						Process,
		HOU.Navio_him							Vessel,
		HOU.Viagem_Him							Voyage,
		Origi.Nome_local						Origin,
		Dest.Nome_local							Delivery,
		Orig.Nome_Local							Loading,
		DstFinal.nome_local						FinalDest,
		HOU.hawb_him							HB,
		HOU.mawb_him							MB,
		ARM.nome_armador						Armador,
		LLP.ETA_LIM								ETA,
		TER.nome_terminal						Terminal,
		PP.apelido								Consignee,
		PS.apelido								Shipper,
		HOU.dt_emis_him							Data_BLH,
		MAS.mawb_mim							BL_MAS,
		MAS.dt_emis_mim							Data_BLM,
		HOU.peso_bruto_him						Peso,
		HOU.vol_tot_him							Cubagem,
		dbo.fbusca_containers(HOU.Num_proc_him)	Containers,
		CONT.Num_lacre_im						Lacre,
		CONT.peso_bruto_im						Tara,
		PC.produto_descr						Produto		

from llp_imp_mar LLP

		left join job_imp_mar					JOB on JOB.num_proc_him = LLP.num_proc_lim
		left join house_imp_mar					HOU on HOU.Num_proc_him = LLP.Num_proc_lim
		left join Localidade					Origi on Origi.cd_local = LLP.cd_planta_lim
		left join Localidade					Dest on Dest.cd_local = Hou.cd_dst_HiM
		left join Localidade					DstFinal on DstFinal.cd_local = LLP.Cd_DstFinal_LiM
		left join Localidade					Orig on Orig.cd_local = HOU.Cd_Org_HiM
		left join armador						ARM	on ARM.cd_armador = JOB.cd_armador
		left join terminal						TER on TER.cd_terminal = LLP.cd_terminal
		left join pessoa						PP	on PP.cd_pes = HOU.cd_consig_him
		left join pessoa						PS	on PS.cd_pes = HOU.cd_export_him
		left join master_imp_mar				MAS on MAS.num_proc_mim = LLP.num_proc_lim
		left join container_mas_imp_mar			CONT on CONT.Num_proc_MiM = LLP.Num_proc_lim
		left join pedido_ship					PSP on PSP.num_proc = LLP.Num_proc_lim
		left join pedido_det					PDET on PDET.cd_pedido = PSP.cd_pedido
		left join pedido						PD on PD.cd_pedido = PDET.cd_pedido
		left join produto_cliente				PC on PC.cd_prod = PD.cd_pedido
where
		LLP.num_proc_lim = @Num_proc


GO
