SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwInvoice_NFValidas]
AS

SELECT 
	I.Num_Proc,I.Cd_Tp_Tx,I.DC,Cd_tp_Moeda,Vlr_Org,Paridade,Vlr_RS,Vlr_Iva,Vlr_Cont_Item,ONF,RTX, 
	F.Numero_Fat,F.Nota_Fiscal,F.Ref_Acesso,F.Emissao,F.Cd_Pes,F.Num_CPF_CNPJ,F.Num_RG_IE,F.Razao_Social,F.Endereco,F.Numero,F.Bairro,F.Cep,F.Cidade,F.UF,F.Pais,
	F.Tipo_Serv,F.Condicoes,F.Prazo,F.Cd_Status,F.Total_NF,F.Total_FAT,F.Observ_NF,F.Aliq_ISS,F.Valor_ISS,F.ISS_Retido,
	F.RPS_Data,F.RPS_NFE,F.RPS_NFE_Verif,F.CdsId,F.SitId,F.Aliq_ISS_Rps,F.RPS_Envio,F.cd_usuario_cancel,F.Habilita_Impostos,
	F.Cd_Usuario,F.Dt_Canc,F.Dt_Cont_Canc,F.dt_envio_ax,F.dt_envio_canc_ax,F.Vencimento,F.Atencao,F.cd_servico,F.Item_lei
	,F.CNAE,F.Descricao
FROM  dbo.NF_Fatura AS F INNER JOIN
            dbo.NF_Fatura_Item AS I ON I.ID=F.ID 
WHERE
	(isnull(cd_status,0) <> 2)


GO
