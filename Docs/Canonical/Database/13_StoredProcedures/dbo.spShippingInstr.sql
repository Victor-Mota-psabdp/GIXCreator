SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[spShippingInstr] --'EMAKZ20080900101'
(
@Num_proc varchar(16)
)
AS
	select 

				LLP.Num_proc_lem				Process,
				HOU.Navio_hem					Vessel,
				HOU.Viagem_Hem					Voyage,
				Origi.Nome_local				Origin,
				Dest.Nome_local					Delivery,
				Orig.Nome_Local					Loading,
				DstFinal.nome_local				FinalDest,
				HOU.hawb_hem					HB,
				HOU.mawb_hem					MB,
				HOU.obs_hem						Remarks,
				ARM.nome_armador				SSLine,
				CTA.Num_DCN_HEM					DebtCred

			from llp_exp_mar LLP

				left join job_Exp_mar			JOB on JOB.num_proc_hem = LLP.num_proc_lem
				left join house_Exp_mar			HOU on HOU.Num_proc_hem = LLP.Num_proc_lem
				left join Localidade			Origi on Origi.cd_local = LLP.cd_planta_lem
				left join Localidade			Dest on Dest.cd_local = Hou.cd_dst_HEM
				left join Localidade			DstFinal on DstFinal.cd_local = LLP.Cd_DstFinal_LEM
				left join Localidade			Orig on Orig.cd_local = HOU.Cd_Org_HEM
				left join armador				ARM	on ARM.cd_armador = LLP.cd_armador_lem
				left join cta_cte_hou_exp_mar   CTA on CTA.num_proc_hem = LLP.Num_proc_lem

			where 

				llp.num_proc_lem = @Num_Proc




GO
