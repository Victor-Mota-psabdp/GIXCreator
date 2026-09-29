SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Eduardo
-- Create date: 12/02/2011
-- Description: Select para Envio de Exccel: Solicitação de Pagamentos em Analise

-- =============================================
CREATE PROCEDURE [dbo].[spATL_SolicitacaoPagamento_alerta]--''

	@all	varchar(3)
AS
BEGIN
	Select 
		Sp.numSol_Pgto					[Referencia],
		SOL.Nome_usuario				[Solicitante],
		Sp.referente					[Referente],
		Sp.valor						[Valor],
		Sp.dt_Vencimento				[Vencimento],
		Cliente.nome_raz_soc			[Cliente]
	From  
		Solicitacao_Pagamento SP with(nolock)
		Left Outer Join Usuario Sol	with(nolock) on SP.cd_solicitante = SOL.Cd_Usuario		
		Left Outer Join Pessoa Cliente with(nolock) on SP.cd_cliente = Cliente.Cd_Pes
	Where
		Sp.autorizado = 'E' and SP.ck_ativo = '1'
END

--SELECT distinct
--		--MC.CdMercadoria,
--		--MC.APMercadoria,
--		convert(varchar(max),MC.MMDEscricaoportugues),
--		--N.CDNCM,
--		--substring(NRPROCESSO,3,3),		
--		--(case when substring(NRPROCESSO,3,3) = 'CSR' then 'GRUPO DOW' else
--		--	(case when substring(NRPROCESSO,3,3) = 'GVD' then 'GRUPO GIVAUDAN' else
--		--		(case when substring(NRPROCESSO,3,3) = 'GVA' then 'GRUPO GIVAUDAN AROMA' else
--		--			(case when substring(NRPROCESSO,3,3) = 'ROB' then 'GRUPO ROHM & HAAS'
--		--			end)
--		--		end)
--		--	end)
--		--end) [Grupo],
--		--pc.Descricao_Longa,
--		p.cd_prod		
--	FROM 
--		iglobal.dbo.PROCESSO PR with(nolock)
--		join iglobal.dbo.DICAPA DC with(nolock) on DC.IDPROCESSO = PR.IDPROCESSO
--		join iglobal.dbo.DIITEM ITEM with(nolock) on ITEM.IDProcesso = DC.IDPROCESSO and ITEM.IDDICAPA = DC.IDDICAPA
--		join iglobal.dbo.Mercadoria MC on ITEM.IDMERCADORIA = MC.idMERCADORIA
--		left join iglobal.dbo.NCM N with(nolock) on MC.IDNCM = N.IDNCM
--		join produto_cliente p on P.cd_Proc_Cliente =  MC.CdMercadoria Collate SQL_Latin1_General_CP1_CI_AS
--		left join produto_chb PC on PC.cd_prod=P.cd_prod 
--	WHERE 
--		--substring(NRPROCESSO,3,3) in ('GVD')
--		--substring(NRPROCESSO,3,3) in ('GVA')
--		substring(NRPROCESSO,3,3) in ('CSR','ROB')
--		and isnull(MC.MMDEscricaoportugues,'') <> ''



GO
