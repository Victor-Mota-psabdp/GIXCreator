SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from Nota_Cliente 
where
	isnumeric(Nota_Fiscal) = 1 and
	Num_Proc = 'IMSLA201201040BR' and convert(int,Nota_Fiscal) = convert(int,'3908')


spNF_Sel 'IMSLA201201040BR', '3908', 'SOLUTIA 000489'
spNF_Sel 'IMCSR20080634001','009768','DOW AGROSCIE 1218536'
*/

CREATE PROCEDURE [dbo].[spNF_Sel]
(
	@Processo		VarChar(16),
	@Nota_Fiscal	VarChar(20),
	@Cliente		Varchar(50)
)
AS
	Declare	@Cd_Cliente Varchar(10)
	Set @Cd_Cliente =(select Cd_Pes from Pessoa where Apelido = @Cliente)

	if isnumeric(@Nota_Fiscal) = 1
		BEGIN
			Select  
				ID_NF, CNPJ, Emissao, CFOP, Invoice, Cd_Exportador, Vlr_NF, Complementar, ID_NF_FK, DI, Data_DI, Paridade,
				Data_Envio, mensagem_erro, cnpj_destinatario, serie, intnlog, IntNAleatorio, intDigitocontrole, cd_ibge_municipio_gerador,
				cd_ibge_municipio_emitente, cd_ibge_municipio_destinatario, cd_pais_bacen, vlr_tot_base_icms, vlr_tot_icms, vlr_tot_base_icms_st,
				vlr_tot_icms_st, vlr_tot_prod_serv, vlr_tot_frete, vlr_tot_desconto, vlr_tot_ipi, vlr_tot_pis, vlr_tot_cofins, vlr_tot_outras_desp,
				cd_transp, info_complementar, apelido
			From  
				Nota_Cliente NC with(nolock)
				Join Pessoa PP with(nolock) on pp.cd_pes=cd_cliente
			Where
				isnumeric(Nota_Fiscal) = 1 and
				Num_Proc = @Processo and convert(int,Nota_Fiscal) = convert(int,@Nota_Fiscal)
				and cfop is not null
		END
	else
		BEGIN
			Select  
				ID_NF, CNPJ, Emissao, CFOP, Invoice, Cd_Exportador, Vlr_NF, Complementar, ID_NF_FK, DI, Data_DI, Paridade,
				Data_Envio, mensagem_erro, cnpj_destinatario, serie, intnlog, IntNAleatorio, intDigitocontrole, cd_ibge_municipio_gerador,
				cd_ibge_municipio_emitente, cd_ibge_municipio_destinatario, cd_pais_bacen, vlr_tot_base_icms, vlr_tot_icms, vlr_tot_base_icms_st,
				vlr_tot_icms_st, vlr_tot_prod_serv, vlr_tot_frete, vlr_tot_desconto, vlr_tot_ipi, vlr_tot_pis, vlr_tot_cofins, vlr_tot_outras_desp,
				cd_transp, info_complementar, apelido
			From  
				Nota_Cliente NC with(nolock)
				Join Pessoa PP with(nolock) on pp.cd_pes=cd_cliente
			Where
				Num_Proc = @Processo and Nota_Fiscal = @Nota_Fiscal
				and cfop is not null
		END



GO
