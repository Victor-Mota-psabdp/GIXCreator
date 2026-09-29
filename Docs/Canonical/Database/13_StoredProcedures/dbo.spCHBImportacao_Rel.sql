SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCHBImportacao_Rel]--'IACSR201602004BR'
(			
	@Processo Varchar(16)
)
AS

select
			Num_Proc_LIM		Processo,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,5) DI,
			dbo.fBusca_DATA_PO_Modal(LLP.Num_Proc_LIM,5) Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,1) PO,
			HOU.Navio_HIM		Navio,
			HOU.HAWB_HIM		HAWB,
			HOU.MAWB_HIM		MAWB,
			LLP.ETA_LIM			Prev_Cheg,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,9) Customer_PO,
			dbo.fNCM (LLP.Num_Proc_LIM) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_LIM) [GMID] ,
			
			HOU.tp_frete_him frete,
			HOU.Vlr_Frete_Efet_HIM	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,23) [L.I.],
	
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			HOU.Peso_Bruto_HIM Bruto,
			HOU.Peso_Liquido_HIM Liquido,
			US.Nome_Usuario	,
			[dbo].[fBusca_PRODUTO](LLP.Num_Proc_Lim) Produto
	from 
			LLP_IMP_MAR LLP With(nolock)
			join House_imp_mar			HOU With(nolock) on HOu.num_proc_him = LLp.num_proc_lim
			join Job_Imp_Mar			JOB With(nolock) on JOB.num_proc_him = LLp.num_proc_lim
			join Usuario				US	With(nolock) on US.Cd_Usuario = JOB.cd_usuario
			Join Pessoa					CSG	With(nolock) on HOU.Cd_Consig_Him = CSG.Cd_pes
			Left Join Endereco			CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa					EXP	With(nolock) on HOU.Cd_Export_HIM = EXP.Cd_pes
			Left Join Endereco			EXPEND with(nolock) on EXPEND.cd_pes=EXP.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa			FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_LIM,1)
			Left Join Endereco			FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'					
	where
			LLP.Num_Proc_LIM = @Processo

union All

	select
			Num_Proc_LIA		Processo,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIA,5) DI,
			dbo.fBusca_DATA_PO_Modal(LLP.Num_Proc_LIA,5) Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIA,1)	PO,
			null				Navio,
			HOU.HAWB_HIA		HAWB,
			HOU.MAWB_HIA		MAWB,
			LLP.ETA_LIA			Prev_Cheg,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIA,9)	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Lia) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_Lia) [GMID] ,
			
			HOU.Tp_Frete_HIA frete,
			HOU.Vlr_Frete_Efet_HIA	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,23) [L.I.],
			
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			HOU.Peso_Bruto_HIA Bruto,
			HOU.Peso_Real_HIA Liquido,
			US.Nome_Usuario,
			[dbo].[fBusca_PRODUTO](LLP.Num_Proc_Lia) Produto			
	from 
			LLP_IMP_AER LLP	With(nolock)
			join House_Imp_Aer				HOU With(nolock) on HOu.num_proc_hia = LLp.num_proc_lia
			join Job_Imp_Aer				JOB With(nolock) on JOB.num_proc_hia = LLp.Num_Proc_Lia
			join Usuario					US	With(nolock) on US.Cd_Usuario = JOB.cd_usuario
			Join Pessoa						CSG	With(nolock) on HOU.Cd_Consig_HIA = CSG.Cd_pes
			Left Join Endereco				CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa						EXP	With(nolock) on HOU.Cd_Export_HIA = EXP.Cd_pes
			Left Join Endereco				EXPEND with(nolock) on EXPEND.cd_pes=CSG.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa				FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_LIA,1)
			Left Join Endereco				FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'
			
	where
			LLP.Num_Proc_LIA = @Processo

union All

	select
			Num_Proc_LIO		Processo,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,5) DI,
			dbo.fBusca_DATA_PO_Modal(LLP.Num_Proc_LIO,5) Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,1) PO,
			null				Navio,
			HOU.HAWB_HIO		HAWB,
			HOU.MAWB_HIO		MAWB,
			LLP.ETA_LIO			Prev_Cheg,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,9) Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Lio) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_LIO) [GMID] ,
			
			HOU.Tp_Frete_HIO frete,
			HOU.Vlr_Frete_Efet_HIO	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,23) [L.I.],
			
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			HOU.Peso_Bruto_HIO Bruto,
			HOU.Peso_Real_HIO Liquido,
			US.Nome_Usuario,
			[dbo].[fBusca_PRODUTO](LLP.Num_Proc_Lio) Produto			
	
	from 
			LLP_IMP_OUT LLP	With(nolock)
			Join House_IMP_OUT			HOU With(nolock) on LLP.Num_Proc_LIO = HOU.Num_Proc_HIO			
			join Usuario				US	With(nolock) on US.Cd_Usuario = LLP.cd_usuario
			Join Pessoa					CSG	With(nolock) on HOU.Cd_Consig_Hio = CSG.Cd_pes
			Left Join Endereco			CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa					EXP	With(nolock) on HOU.Cd_Export_HIO = EXP.Cd_pes
			Left Join Endereco			EXPEND with(nolock) on EXPEND.cd_pes=CSG.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa			FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_Lio,1)
			Left Join Endereco			FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'		
	where
			LLP.Num_Proc_LIO = @Processo

-- MASTER -------------------------------

UNION ALL

	select
			LLP.Num_Proc_Master	Processo,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,5) DI,
			dbo.fBusca_DATA_PO_Modal(LLP.Num_Proc_Master,5) Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,1) PO,
			MAS.Navio_MIM		Navio,
			''					HAWB,
			MAS.MAWB_MIM		MAWB,
			LLP.ETA_Master		Prev_Cheg,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,9) Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Master) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_Master) [GMID],
			
					
			MAS.Tp_Frete_MIM frete,
			MAS.Vlr_Frete_MIM	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,23) [L.I.] ,
			
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			MAS.Peso_Bruto_MIM Bruto,
			MAS.Peso_Bruto_MIM Liquido,
			'' Nome_Usuario	,
			'' Produto		
	from  LLP_Master LLP	With(nolock)
			Join MASTER_IMP_MAR			MAS With(nolock) on LLP.Num_Proc_Master = MAS.Num_Proc_MIM			
			Join Pessoa					CSG	With(nolock) on MAS.Cd_Consig_MIM = CSG.Cd_pes 
			Left Join Endereco			CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa					EXP	With(nolock) on MAS.Cd_Export_MIM = EXP.Cd_pes
			Left Join Endereco			EXPEND with(nolock) on EXPEND.cd_pes=CSG.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa			FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_Master,1)
			Left Join Endereco			FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'
			
	where
			LLP.Num_Proc_Master = @Processo

/* 17-03-2016 Alterado Para pegar dados da PO atravez da função
	select
			Num_Proc_LIM		Processo,
			DI.Numero_PO_HIM	DI,
			DI.Data_PO_HIM		Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIM	PO,
			HOU.Navio_HIM		Navio,
			HOU.HAWB_HIM		HAWB,
			HOU.MAWB_HIM		MAWB,
			LLP.ETA_LIM			Prev_Cheg,
			CP.Numero_PO_HIM	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_LIM) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_LIM) [GMID] ,
			
			HOU.tp_frete_him frete,
			HOU.Vlr_Frete_Efet_HIM	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,23) [L.I.],
	
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			HOU.Peso_Bruto_HIM Bruto,
			HOU.Peso_Liquido_HIM Liquido,
			US.Nome_Usuario	,
			[dbo].[fBusca_PRODUTO](LLP.Num_Proc_Lim) Produto
	from 
			LLP_IMP_MAR LLP With(nolock)
			join House_imp_mar			HOU With(nolock) on HOu.num_proc_him = LLp.num_proc_lim
			join Job_Imp_Mar			JOB With(nolock) on JOB.num_proc_him = LLp.num_proc_lim
			join Usuario				US	With(nolock) on US.Cd_Usuario = JOB.cd_usuario
			Join Pessoa					CSG	With(nolock) on HOU.Cd_Consig_Him = CSG.Cd_pes
			Left Join Endereco			CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa					EXP	With(nolock) on HOU.Cd_Export_HIM = EXP.Cd_pes
			Left Join Endereco			EXPEND with(nolock) on EXPEND.cd_pes=EXP.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa			FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_LIM,1)
			Left Join Endereco			FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'
			Left Join PO_HIM			DI With(nolock)	on LLP.Num_proc_Lim = DI.Num_proc_him and DI.ID_DC = 5
			Left Join PO_HIM			PO	With(nolock) on LLP.Num_proc_Lim = PO.Num_proc_him and PO.ID_DC = 1
			Left Join PO_HIM			CP	With(nolock) on LLP.Num_proc_Lim = CP.Num_proc_him and CP.ID_DC = 9						
	where
			LLP.Num_Proc_LIM = @Processo

union All

	select
			Num_Proc_LIA		Processo,
			DI.Numero_PO_HIA	DI,
			DI.Data_PO_HIA		Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIA	PO,
			null				Navio,
			HOU.HAWB_HIA		HAWB,
			HOU.MAWB_HIA		MAWB,
			LLP.ETA_LIA			Prev_Cheg,
			CP.Numero_PO_HIA	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Lia) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_Lia) [GMID] ,
			
			HOU.Tp_Frete_HIA frete,
			HOU.Vlr_Frete_Efet_HIA	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.num_proc_lia,23) [L.I.],
			
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			HOU.Peso_Bruto_HIA Bruto,
			HOU.Peso_Real_HIA Liquido,
			US.Nome_Usuario,
			[dbo].[fBusca_PRODUTO](LLP.Num_Proc_Lia) Produto			
	from 
			LLP_IMP_AER LLP	With(nolock)
			join House_Imp_Aer				HOU With(nolock) on HOu.num_proc_hia = LLp.num_proc_lia
			join Job_Imp_Aer				JOB With(nolock) on JOB.num_proc_hia = LLp.Num_Proc_Lia
			join Usuario					US	With(nolock) on US.Cd_Usuario = JOB.cd_usuario
			Join Pessoa						CSG	With(nolock) on HOU.Cd_Consig_HIA = CSG.Cd_pes
			Left Join Endereco				CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa						EXP	With(nolock) on HOU.Cd_Export_HIA = EXP.Cd_pes
			Left Join Endereco				EXPEND with(nolock) on EXPEND.cd_pes=CSG.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa				FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_LIA,1)
			Left Join Endereco				FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'
			Left Outer Join PO_HIA			DI	With(nolock) on LLP.Num_Proc_LIA = DI.Num_Proc_HIA and DI.ID_DC = 5
			Left Outer Join PO_HIA			PO	With(nolock) on LLP.Num_Proc_LIA = PO.Num_proc_hia and PO.ID_DC = 1
			Left outer join PO_HIA			CP	With(nolock) on LLP.Num_proc_LiA = CP.Num_proc_hia and CP.ID_DC = 9
			
	where
			LLP.Num_Proc_LIA = @Processo

union All

	select
			Num_Proc_LIO		Processo,
			DI.Numero_PO_HIO	DI,
			DI.Data_PO_HIO		Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIO	PO,
			null				Navio,
			HOU.HAWB_HIO		HAWB,
			HOU.MAWB_HIO		MAWB,
			LLP.ETA_LIO			Prev_Cheg,
			CP.Numero_PO_HIO	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Lio) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_LIO) [GMID] ,
			
			HOU.Tp_Frete_HIO frete,
			HOU.Vlr_Frete_Efet_HIO	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,23) [L.I.],
			
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			HOU.Peso_Bruto_HIO Bruto,
			HOU.Peso_Real_HIO Liquido,
			US.Nome_Usuario,
			[dbo].[fBusca_PRODUTO](LLP.Num_Proc_Lio) Produto			
	
	from 
			LLP_IMP_OUT LLP	With(nolock)
			Join House_IMP_OUT			HOU With(nolock) on LLP.Num_Proc_LIO = HOU.Num_Proc_HIO			
			join Usuario				US	With(nolock) on US.Cd_Usuario = LLP.cd_usuario
			Join Pessoa					CSG	With(nolock) on HOU.Cd_Consig_Hio = CSG.Cd_pes
			Left Join Endereco			CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa					EXP	With(nolock) on HOU.Cd_Export_HIO = EXP.Cd_pes
			Left Join Endereco			EXPEND with(nolock) on EXPEND.cd_pes=CSG.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa			FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_Lio,1)
			Left Join Endereco			FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'
			Left Join PO_HIO			DI With(nolock)	on LLP.Num_proc_Lio = DI.Num_proc_hio and DI.ID_DC = 5
			Left Join PO_HIO			PO	With(nolock) on LLP.Num_proc_Lio = PO.Num_proc_hio and PO.ID_DC = 1
			Left Join PO_HIO			CP	With(nolock) on LLP.Num_proc_Lio = CP.Num_proc_hio and CP.ID_DC = 9			
	where
			LLP.Num_Proc_LIO = @Processo

-- MASTER -------------------------------

UNION ALL

	select
			LLP.Num_Proc_Master	Processo,
			DI.Numero_PO		DI,
			DI.Data_PO			Data_DI,
			--CSG.Apelido			Cliente,
			CSG.Nome_Raz_Soc	Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO		PO,
			MAS.Navio_MIM		Navio,
			''					HAWB,
			MAS.MAWB_MIM		MAWB,
			LLP.ETA_Master		Prev_Cheg,
			CP.Numero_PO		Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Master) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_Master) [GMID],
			
					
			MAS.Tp_Frete_MIM frete,
			MAS.Vlr_Frete_MIM	vlr_frete,
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,2) [Fatura],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,11) [PackingList],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,13) [CertificadoOrigem],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,24) [AtoConcess],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,29) [CEMercante],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Master,23) [L.I.] ,
			
			--CSG.Nome_Raz_Soc consignee,
			CSG.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+CSG.Num_CPF_CNPJ + ' ',' ') +
			isnull(CSGEND.Rua + ' ',' ') +
			isnull(','+ CSGEND.Numero,' ') +
			isnull(' - ' + CSGEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(CSGEND.Cep) + ' ',' ') +
			isnull(CSGEND.Cidade,' ') consignee,
	
			--EXP.Nome_Raz_Soc Exporter,
			EXP.Nome_Raz_Soc + ' ' +
			isnull(EXP.Num_CPF_CNPJ + ' ',' ') +
			isnull(EXPEND.Rua + ' ',' ') +
			isnull(EXPEND.Numero,' ') +
			isnull(' - '+EXPEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(EXPEND.Cep) + ' ',' ') +
			isnull(EXPEND.Cidade,' ') Exporter,
			--FAB.Nome_Raz_Soc Fabricante,					
			FAB.Nome_Raz_Soc + ' ' +
			isnull('CNPJ: '+FAB.Num_CPF_CNPJ + ' ',' ') +
			isnull(FABEND.Rua + ' ',' ') +
			isnull(','+ FABEND.Numero,' ') +
			isnull(' - ' + FABEND.compl_end + ' ',' ') +
			isnull('CEP: '+ltrim(FABEND.Cep) + ' ',' ') +
			isnull(FABEND.Cidade,' ') Fabricante,
			
			MAS.Peso_Bruto_MIM Bruto,
			MAS.Peso_Bruto_MIM Liquido,
			'' Nome_Usuario	,
			'' Produto		
	from  LLP_Master LLP	With(nolock)
			Join MASTER_IMP_MAR			MAS With(nolock) on LLP.Num_Proc_Master = MAS.Num_Proc_MIM			
			Join Pessoa					CSG	With(nolock) on MAS.Cd_Consig_MIM = CSG.Cd_pes 
			Left Join Endereco			CSGEND with(nolock) on CSGEND.cd_pes=CSG.cd_pes and CSGEND.cd_tp_end='COM'
			Join Pessoa					EXP	With(nolock) on MAS.Cd_Export_MIM = EXP.Cd_pes
			Left Join Endereco			EXPEND with(nolock) on EXPEND.cd_pes=CSG.cd_pes and EXPEND.cd_tp_end='COM'
			left Join Pessoa			FAB	With(nolock) on FAB.Cd_pes = [dbo].[fBusca_CampoCliente](LLP.Num_Proc_Master,1)
			Left Join Endereco			FABEND with(nolock) on FABEND.cd_pes=FAB.cd_pes and FABEND.cd_tp_end='COM'
			Left Join PO_Master			DI With(nolock)	on LLP.Num_proc_Master = DI.Num_proc_Master and DI.ID_DC = 5
			Left Join PO_Master			PO	With(nolock) on LLP.Num_proc_Master = PO.Num_proc_Master and PO.ID_DC = 1
			Left Join PO_Master			CP	With(nolock) on LLP.Num_proc_master = CP.Num_proc_master and CP.ID_DC = 9
			
	where
			LLP.Num_Proc_Master = @Processo
*/


/*
ALTER	procedure [dbo].[spCHBImportacao_Rel] --'IMCSR201212610BR'
(			
@Processo Varchar(16)
)
AS

	select
			Num_Proc_LIM		Processo,
			DI.Numero_PO_HIM	DI,
			DI.Data_PO_HIM		Data_DI,
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIM	PO,
			HOU.Navio_HIM		Navio,
			HOU.HAWB_HIM		HAWB,
			HOU.MAWB_HIM		MAWB,
			LLP.ETA_LIM			Prev_Cheg,
			CP.Numero_PO_HIM	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_LIM) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_LIM) [GMID] 
	from 
			LLP_IMP_MAR LLP With(nolock)
			Left Join PO_HIM			DI With(nolock)	on LLP.Num_proc_Lim = DI.Num_proc_him and DI.ID_DC = 5
			Left Join PO_HIM			PO	With(nolock) on LLP.Num_proc_Lim = PO.Num_proc_him and PO.ID_DC = 1
			Left Join PO_HIM			CP	With(nolock) on LLP.Num_proc_Lim = CP.Num_proc_him and CP.ID_DC = 9
			Left Join House_IMP_MAR		HOU With(nolock) on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
			Left Join Pessoa			CSG	With(nolock) on HOU.Cd_Consig_Him = CSG.Cd_pes and desat_pes = 'N'
	where
			LLP.Num_Proc_LIM = @Processo

union All

	select
			Num_Proc_LIA		Processo,
			DI.Numero_PO_HIA	DI,
			DI.Data_PO_HIA		Data_DI,
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIA	PO,
			null				Navio,
			HOU.HAWB_HIA		HAWB,
			HOU.MAWB_HIA		MAWB,
			LLP.ETA_LIA			Prev_Cheg,
			CP.Numero_PO_HIA	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Lia) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_Lia) [GMID] 
	from 
			LLP_IMP_AER LLP	With(nolock)
			Left Outer Join PO_HIA			DI	With(nolock) on LLP.Num_Proc_LIA = DI.Num_Proc_HIA and DI.ID_DC = 5
			Left Outer Join PO_HIA			PO	With(nolock) on LLP.Num_Proc_LIA = PO.Num_proc_hia and PO.ID_DC = 1
			Left outer join PO_HIA			CP	With(nolock) on LLP.Num_proc_LiA = CP.Num_proc_hia and CP.ID_DC = 9
			Left Outer Join House_IMP_AER	HOU With(nolock) on LLP.Num_Proc_LIA = HOU.Num_Proc_HIA
			Left Outer Join Pessoa			CSG	With(nolock) on HOU.Cd_Consig_HIA = CSG.Cd_pes and desat_pes = 'N'
	where
			LLP.Num_Proc_LIA = @Processo

union All

	select
			Num_Proc_LIO		Processo,
			DI.Numero_PO_HIO	DI,
			DI.Data_PO_HIO		Data_DI,
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO_HIO	PO,
			null				Navio,
			HOU.HAWB_HIO		HAWB,
			HOU.MAWB_HIO		MAWB,
			LLP.ETA_LIO			Prev_Cheg,
			CP.Numero_PO_HIO	Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Lio) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_LIO) [GMID] 
	
	from 
			LLP_IMP_OUT LLP	With(nolock)
			Left Join PO_HIO			DI With(nolock)	on LLP.Num_proc_Lio = DI.Num_proc_hio and DI.ID_DC = 5
			Left Join PO_HIO			PO	With(nolock) on LLP.Num_proc_Lio = PO.Num_proc_hio and PO.ID_DC = 1
			Left Join PO_HIO			CP	With(nolock) on LLP.Num_proc_Lio = CP.Num_proc_hio and CP.ID_DC = 9
			Left Join House_IMP_OUT		HOU With(nolock) on LLP.Num_Proc_LIO = HOU.Num_Proc_HIO
			Left Join Pessoa			CSG	With(nolock) on HOU.Cd_Consig_Hio = CSG.Cd_pes and desat_pes = 'N'
	where
			LLP.Num_Proc_LIO = @Processo

-- MASTER -------------------------------

UNION ALL

	select
			LLP.Num_Proc_Master	Processo,
			DI.Numero_PO		DI,
			DI.Data_PO			Data_DI,
			CSG.Apelido			Cliente,
			CSG.Num_CPF_CNPJ	Cliente_CNPJ,
			PO.Numero_PO		PO,
			MAS.Navio_MIM		Navio,
			''					HAWB,
			MAS.MAWB_MIM		MAWB,
			LLP.ETA_Master		Prev_Cheg,
			CP.Numero_PO		Customer_PO,
			dbo.fNCM (LLP.Num_Proc_Master) [NCM],
			dbo.fBusca_GMID (LLP.Num_Proc_Master) [GMID] 
	from 
		LLP_Master LLP	With(nolock)

			Left Join PO_Master			DI With(nolock)	on LLP.Num_proc_Master = DI.Num_proc_Master and DI.ID_DC = 5
			Left Join PO_Master			PO	With(nolock) on LLP.Num_proc_Master = PO.Num_proc_Master and PO.ID_DC = 1
			Left Join PO_Master			CP	With(nolock) on LLP.Num_proc_master = CP.Num_proc_master and CP.ID_DC = 9
			Left Join MASTER_IMP_MAR	MAS With(nolock) on LLP.Num_Proc_Master = MAS.Num_Proc_MIM
			Left Join Pessoa			CSG	With(nolock) on MAS.Cd_Consig_MIM = CSG.Cd_pes and desat_pes = 'N'
	where
			LLP.Num_Proc_Master = @Processo
			
*/
GO
