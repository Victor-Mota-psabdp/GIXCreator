SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	procedure [dbo].[spCHBImportacaoDTA_Rel]--'IAHYU201110006BR'-- 'IMHYU201112003BR'
(			
@Processo Varchar(16)
)
AS

	select
			Num_Proc_LIM		Processo,
			DTA.Numero_PO_HIM	DTA,
			DI.Numero_PO_HIM	DI,			
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIM	SID,
			HOU.Navio_HIM		Navio,
			HOU.viagem_him		Viagem,
			HOU.HAWB_HIM		HAWB,
			HOU.MAWB_HIM		MAWB,
			LLP.ETA_LIM			Prev_Cheg,
			LLP.ATA_LIM			Atracacao,
			TER.nome_terminal	Terminal
	from 
			LLP_IMP_MAR LLP With(nolock)
			Left Join PO_HIM			DTA With(nolock)	on LLP.Num_proc_Lim = DTA.Num_proc_him and DTA.ID_DC = 045
			Left Join PO_HIM			DI With(nolock)	on LLP.Num_proc_Lim = DI.Num_proc_him and DI.ID_DC = 5
			Left Join PO_HIM			PO	With(nolock) on LLP.Num_proc_Lim = PO.Num_proc_him and PO.ID_DC = 1
			Left Join House_IMP_MAR		HOU With(nolock)  on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
			Left Join Pessoa			CSG	With(nolock) on HOU.Cd_Consig_Him = CSG.Cd_pes and desat_pes = 'N'
			left join terminal			ter with(nolock) on Ter.cd_terminal = llp.cd_terminal
	where
			LLP.Num_Proc_LIM = @Processo

union All

	select
			Num_Proc_LIA		Processo,
			DTA.Numero_PO_HIA	DTA,
			DI.Numero_PO_HIA	DI,
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIA	SID,
			nome_cia_aer		Navio,
			voo_hia				Viagem,
			HOU.HAWB_HIA		HAWB,
			HOU.MAWB_HIA		MAWB,
			LLP.ETA_LIA			Prev_Cheg,
			LLP.ATA_LIA			Atracacao,
			TER.nome_terminal	Terminal
	from 
			LLP_IMP_AER LLP	With(nolock)
			Left Outer Join PO_HIA			DTA	With(nolock) on LLP.Num_Proc_LIA = DTA.Num_Proc_HIA and DTA.ID_DC = 45
			Left Join PO_HIA				DI With(nolock)	on LLP.Num_proc_Lia = DI.Num_proc_hia and DI.ID_DC = 5
			Left Outer Join PO_HIA			PO	With(nolock) on LLP.Num_Proc_LIA = PO.Num_proc_hiA and PO.ID_DC = 1
			Left Outer Join House_IMP_AER	HOU With(nolock) on LLP.Num_Proc_LIA = HOU.Num_Proc_HIA
			Left Outer Join Pessoa			CSG	With(nolock) on HOU.Cd_Consig_HIA = CSG.Cd_pes and desat_pes = 'N'
			left join terminal				TER with(nolock) on Ter.cd_terminal = llp.cd_terminal
			left join job_imp_aer			JOB With(nolock) on JOB.Num_Proc_HIA = LLP.Num_Proc_LIA
			left join cia_aerea				CIA with(nolock) on CIA.cd_cia_aer = JOB.cd_cia_aer
	where
			LLP.Num_Proc_LIA = @Processo

union All

	select
			Num_Proc_LIO		Processo,
			DTA.Numero_PO_HIO	DTA,
			DI.Numero_PO_HIO	DI,
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIO	SID,
			null				Navio,
			null				Viagem,
			HOU.HAWB_HIO		HAWB,
			HOU.MAWB_HIO		MAWB,
			LLP.ETA_LIO			Prev_Cheg,
			LLP.ATA_LIO			Atracacao,
			TER.nome_terminal	Terminal
	from 
			LLP_IMP_OUT LLP	With(nolock)
			Left Join PO_HIO			DTA With(nolock)	on LLP.Num_proc_Lio = DTA.Num_proc_hio and DTA.ID_DC = 45
			Left Join PO_HIO			DI With(nolock)	on LLP.Num_proc_Lio = DI.Num_proc_hio and DI.ID_DC = 5
			Left Join PO_HIO			PO	With(nolock) on LLP.Num_proc_Lio = PO.Num_proc_hio and PO.ID_DC = 1
			Left Join House_IMP_OUT		HOU With(nolock) on LLP.Num_Proc_LIO = HOU.Num_Proc_HIO
			Left Join Pessoa			CSG	With(nolock) on HOU.Cd_Consig_Hio = CSG.Cd_pes and desat_pes = 'N'
			left join terminal			ter with(nolock) on Ter.cd_terminal = llp.cd_terminal
	where
			LLP.Num_Proc_LIO = @Processo

---- MASTER -------------------------------
--UNION ALL
--
--	select
--			LLP.Num_Proc_Master	Processo,
--			DI.Numero_PO		DI,
--			DI.Data_PO			Data_DI,
--			CSG.Apelido			Cliente,
--			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
--			PO.Numero_PO		PO,
--			MAS.Navio_MIM		Navio,
--			''					HAWB,
--			MAS.MAWB_MIM		MAWB,
--			LLP.ETA_Master		Prev_Cheg
--	from 
--			LLP_Master LLP	With(nolock)
--			Left Join PO_Master			DI With(nolock)	on LLP.Num_proc_Master = DI.Num_proc_Master and DI.ID_DC = 5
--			Left Join PO_Master			PO	With(nolock) on LLP.Num_proc_Master = PO.Num_proc_Master and PO.ID_DC = 1
--			Left Join MASTER_IMP_MAR	MAS With(nolock) on LLP.Num_Proc_Master = MAS.Num_Proc_MIM
--			Left Join Pessoa			CSG	With(nolock) on MAS.Cd_Consig_MIM = CSG.Cd_pes and desat_pes = 'N'
--	where
--			LLP.Num_Proc_Master = @Processo
--
--
--
--
--

GO
