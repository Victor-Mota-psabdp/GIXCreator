SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Boleto add cd_banco varchar(3)
--ALTER TABLE Boleto_Instrucao_Cobranca ADD Cd_Banco Varchar(3)
--ALTER TABLE Boleto_Instrucao_Cobranca ADD Ativo bit null
--ALTER TABLE Boleto_Instrucao_Cobranca ADD  [Dt_Ins] Datetime null
--ALTER TABLE Boleto_Instrucao_Cobranca ADD Cd_Usuario Varchar(10) null
----update Boleto_Instrucao_Cobranca set Ativo = 1, Dt_Ins = getdate(), Cd_Usuario = 'CE'
--sp_help Boleto_Instrucao_Cobranca
CREATE Procedure [dbo].[spBoleto_Sel]--'90000002'--'IMMCO201306001BRB'
	
	@fatcod		varchar(17)

as
/*
exec [spBoleto_Sel] '90075686'
*/

SET NOCOUNT ON

Declare @Temp Table
(
	Fatura			Varchar(17),
	Sacado			Varchar(500),
	CNPJ			Varchar(50),
	Vencimento		Datetime,
	Agencia			Varchar(50),
	Conta			Varchar(50),
	Valor			Decimal(10,2),
	DtTxt			Datetime,
	NossoNumero		Varchar(50),
	instrucao01		Varchar(500),
	instrucao02		Varchar(500),
	Rua				Varchar(40),
	Numero			Varchar(10),
	Bairro			Varchar(100),
	CEP				varchar(8),
	Cidade			varchar(25),
	UF				varchar(2),
	Complemento		varchar(25),
	cd_banco		varchar(3) --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
)

	
		if len(@fatcod)= 8
			BEGIN
				insert into @Temp
					select 
						Numero_Fat Fatura,
						Razao_Social Sacado,
						num_CPF_CNPJ CNPJ,
						Vencimento Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
						convert(decimal(10,2),Total_FAT) Valor,		
						dt_emissao_txt DtTxt,
						cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(NF.Endereco,'') Rua,
						isnull(NF.Numero,'') Numero,
						isnull(E.Bairro,'') Bairro, -- Alessandra 22/03/20222 - VERIFICAR A IDEIA COM O ANDERSON
						isnull(replace(NF.CEP,'-',''),'') CEP,
						isnull(NF.Cidade,'') Cidade,
						isnull(NF.UF,'') UF,
						isnull(E.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					from NF_Fatura NF
						left join endereco E on E.cd_pes = NF.cd_pes and E.cd_tp_end = 'COM'
						left join boleto B on B.fatcod = NF.Numero_Fat
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					where 
						Numero_Fat = @fatcod and Cd_Status <> 2		
						


			End
		else
			BEGIN
				insert into @Temp
					select 
						F.FatCod Fatura,
						P.nome_raz_soc Sacado,
						P.num_cpf_cnpj CNPJ,
						F.FatDtVenc Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
				--		sum(vlr_org) Valor,
						convert(decimal(10,2),sum(I.Paridade * dbo.valor(vlr_org,DC))) Valor,
				--		sum(isnull([dbo].[fParidadeFaturaARG](I.num_proc,cd_tp_moeda),dbo.FConverterMoeda(cd_tp_moeda,'REL')) * dbo.valor(vlr_org,DC)) Valor,					
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(E.Rua,'') Rua,
						isnull(E.numero,'') Numero,
						isnull(E.Bairro,'') Bairro,
						isnull(replace(E.CEP,'-',''),'') CEP,
						isnull(E.Cidade,'') Cidade,
						isnull(E.UF,'') UF,
						isnull(E.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					from fatura F
						join item_fat I on I.fatcod = F.fatcod
						join pessoa P on P.cd_pes = F.cd_pes
						left join endereco E on E.cd_pes = F.cd_pes and E.cd_tp_end = 'COM'
						left join boleto B on B.fatcod = F.fatcod
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left Join Fatura_CHB FAT with(nolock)on F.fatcod=FAT.FATURA_PC
					where  
						F.fatcod = @fatcod  and F.fatstatus = 1
						and FAT.FATURA_PC is null
					group by 
						F.FatCod ,nome_raz_soc,num_cpf_cnpj,FatDtVenc,dt_emissao_txt,
						cd_boleto,B01.cd_instrucao,B02.cd_instrucao,B01.nome_instrucao,B02.nome_instrucao,
						E.Rua,E.Numero,E.Cep,E.Bairro,E.Cidade,E.UF,Compl_End, b.cd_banco --Alessandra 22/03/2022
						,B.Agencia_Cedente,	B.Conta_Cedente
					
				UNION ALL
					select	
						FAT.FATURA_PC Fatura,
						PP.nome_raz_soc Sacado,
						PP.num_cpf_cnpj CNPJ,
						FT.FatDtVenc Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
						convert(decimal(10,2),sum(dbo.valor(IFT.Vlr_RS,IFT.DC))) Valor,			
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(ED.Rua,'') Rua,
						isnull(ED.numero,'') Numero,
						isnull(ED.Bairro,'') Bairro,
						isnull(replace(ED.CEP,'-',''),'') CEP,
						isnull(ED.Cidade,'') Cidade,
						isnull(ED.UF,'') UF,
						isnull(ED.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					FROM 
						FATURA_CHB FAT with(nolock)
						Join Fatura FT with(nolock)on FT.fatcod=FAT.bdp_Invoice
						Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
						JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
						LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'	
						join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx	
						left join boleto B on B.fatcod = FT.fatcod
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta		
					WHERE 
						FAT.FATURA_PC=@fatcod and FT.fatstatus = 1
					Group by
						FAT.FATURA_PC,PP.nome_raz_soc,PP.num_cpf_cnpj,FT.FatDtVenc,		
						B.dt_emissao_txt,B.cd_boleto ,B01.cd_instrucao,B01.nome_instrucao,B02.cd_instrucao,B02.nome_instrucao,
						ED.Rua,ED.numero,ED.Bairro,ED.CEP,ED.Cidade,ED.UF,ED.Compl_End, b.cd_banco --Alessandra 22/03/2022
						,B.Agencia_Cedente,	B.Conta_Cedente
				UNION ALL
					SELECT 
						FAT.FATURA_PC Fatura,
						PP.nome_raz_soc Sacado,
						PP.num_cpf_cnpj CNPJ,
						FT.FatDtVenc Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
						--abs(convert(decimal(10,2),sum(dbo.valor(ITM.VLR_PC,ITM.DC)))) Valor,

			----antonio 20/01/2023 
						--abs(convert(decimal(10,2),sum(ITM.VLR_PC))) Valor,
						(case
							when TT.Ref_Ctb_Tx='ADT' then convert(decimal(10,2),sum(ITM.VLR_PC)*-1) 
   							else 
								 convert(decimal(10,2),sum(ITM.VLR_PC)) 
 						end) Valor,

						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(ED.Rua,'') Rua,
						isnull(ED.numero,'') Numero,
						isnull(ED.Bairro,'') Bairro,
						isnull(replace(ED.CEP,'-',''),'') CEP,
						isnull(ED.Cidade,'') Cidade,
						isnull(ED.UF,'') UF,
						isnull(ED.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					FROM 
						FATURA_CHB FAT with(nolock)
						JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC and imprime='S' and tp_pgto = 'B'	
						JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
						LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'			
						join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx	
						left join boleto B on B.fatcod = FAT.FATURA_PC
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						Join Fatura FT with(nolock)on FT.fatcod=FAT.FATURA_PC			
					WHERE 
						FAT.FATURA_PC=@fatcod and FT.fatstatus = 1
					Group By
						FAT.FATURA_PC,PP.nome_raz_soc,PP.num_cpf_cnpj,FT.FatDtVenc,		
						B.dt_emissao_txt,B.cd_boleto ,B01.cd_instrucao,B01.nome_instrucao,B02.cd_instrucao,B02.nome_instrucao,
						ED.Rua,ED.numero,ED.Bairro,ED.CEP,ED.Cidade,ED.UF,ED.Compl_End, b.cd_banco --Alessandra 22/03/2022
						,B.Agencia_Cedente,	B.Conta_Cedente
	-- Antonio 20/01/2023
                        ,TT.Ref_Ctb_Tx
					
			END

Select
	Fatura,Sacado,CNPJ,MAx(Vencimento) Vencimento,
	Agencia +'-'+ A.Nome_Agencia Agencia,
	Conta,
	sum(Valor) Valor,DtTxt,NossoNumero,instrucao01,instrucao02,Rua,
	Numero,Bairro,CEP,Cidade,UF,Complemento,
	T.cd_banco+'-'+ B.Nome_Banco  cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
from 
	@Temp T
	left join Banco B on B.cd_banco = T. cd_banco
	Left Join Agencia A on A.cd_agencia = T.Agencia
group by
	Fatura,Sacado,CNPJ,Agencia,Conta,DtTxt,NossoNumero,instrucao01,instrucao02,Rua,
	Numero,Bairro,CEP,Cidade,UF,Complemento,T.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta	
	,A.Nome_Agencia,B.Nome_Banco

/*
USE [Atlantis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Boleto add cd_banco varchar(3)
--ALTER TABLE Boleto_Instrucao_Cobranca ADD Cd_Banco Varchar(3)
--ALTER TABLE Boleto_Instrucao_Cobranca ADD Ativo bit null
--ALTER TABLE Boleto_Instrucao_Cobranca ADD  [Dt_Ins] Datetime null
--ALTER TABLE Boleto_Instrucao_Cobranca ADD Cd_Usuario Varchar(10) null
----update Boleto_Instrucao_Cobranca set Ativo = 1, Dt_Ins = getdate(), Cd_Usuario = 'CE'
--sp_help Boleto_Instrucao_Cobranca
ALTER Procedure [dbo].[spBoleto_Sel]--'90000002'--'IMMCO201306001BRB'
	
	@fatcod		varchar(17)

as
---exec [spBoleto_Sel] '90075686'

SET NOCOUNT ON

Declare @Temp Table
(
	Fatura			Varchar(17),
	Sacado			Varchar(500),
	CNPJ			Varchar(50),
	Vencimento		Datetime,
	Agencia			Varchar(50),
	Conta			Varchar(50),
	Valor			Decimal(10,2),
	DtTxt			Datetime,
	NossoNumero		Varchar(50),
	instrucao01		Varchar(500),
	instrucao02		Varchar(500),
	Rua				Varchar(40),
	Numero			Varchar(10),
	Bairro			Varchar(100),
	CEP				varchar(8),
	Cidade			varchar(25),
	UF				varchar(2),
	Complemento		varchar(25),
	cd_banco		varchar(3) --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
)

	
		if len(@fatcod)= 8
			BEGIN
				insert into @Temp
					select 
						Numero_Fat Fatura,
						Razao_Social Sacado,
						num_CPF_CNPJ CNPJ,
						Vencimento Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
						convert(decimal(10,2),Total_FAT) Valor,		
						dt_emissao_txt DtTxt,
						cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(NF.Endereco,'') Rua,
						isnull(NF.Numero,'') Numero,
						isnull(E.Bairro,'') Bairro, -- Alessandra 22/03/20222 - VERIFICAR A IDEIA COM O ANDERSON
						isnull(replace(NF.CEP,'-',''),'') CEP,
						isnull(NF.Cidade,'') Cidade,
						isnull(NF.UF,'') UF,
						isnull(E.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					from NF_Fatura NF
						left join endereco E on E.cd_pes = NF.cd_pes and E.cd_tp_end = 'COM'
						left join boleto B on B.fatcod = NF.Numero_Fat
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					where 
						Numero_Fat = @fatcod and Cd_Status <> 2		
						


			End
		else
			BEGIN
				insert into @Temp
					select 
						F.FatCod Fatura,
						P.nome_raz_soc Sacado,
						P.num_cpf_cnpj CNPJ,
						F.FatDtVenc Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
				--		sum(vlr_org) Valor,
						convert(decimal(10,2),sum(I.Paridade * dbo.valor(vlr_org,DC))) Valor,
				--		sum(isnull([dbo].[fParidadeFaturaARG](I.num_proc,cd_tp_moeda),dbo.FConverterMoeda(cd_tp_moeda,'REL')) * dbo.valor(vlr_org,DC)) Valor,					
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(E.Rua,'') Rua,
						isnull(E.numero,'') Numero,
						isnull(E.Bairro,'') Bairro,
						isnull(replace(E.CEP,'-',''),'') CEP,
						isnull(E.Cidade,'') Cidade,
						isnull(E.UF,'') UF,
						isnull(E.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					from fatura F
						join item_fat I on I.fatcod = F.fatcod
						join pessoa P on P.cd_pes = F.cd_pes
						left join endereco E on E.cd_pes = F.cd_pes and E.cd_tp_end = 'COM'
						left join boleto B on B.fatcod = F.fatcod
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left Join Fatura_CHB FAT with(nolock)on F.fatcod=FAT.FATURA_PC
					where  
						F.fatcod = @fatcod  and F.fatstatus = 1
						and FAT.FATURA_PC is null
					group by 
						F.FatCod ,nome_raz_soc,num_cpf_cnpj,FatDtVenc,dt_emissao_txt,
						cd_boleto,B01.cd_instrucao,B02.cd_instrucao,B01.nome_instrucao,B02.nome_instrucao,
						E.Rua,E.Numero,E.Cep,E.Bairro,E.Cidade,E.UF,Compl_End, b.cd_banco --Alessandra 22/03/2022
						,B.Agencia_Cedente,	B.Conta_Cedente
					
				UNION ALL
					select	
						FAT.FATURA_PC Fatura,
						PP.nome_raz_soc Sacado,
						PP.num_cpf_cnpj CNPJ,
						FT.FatDtVenc Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
						convert(decimal(10,2),sum(dbo.valor(IFT.Vlr_RS,IFT.DC))) Valor,			
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(ED.Rua,'') Rua,
						isnull(ED.numero,'') Numero,
						isnull(ED.Bairro,'') Bairro,
						isnull(replace(ED.CEP,'-',''),'') CEP,
						isnull(ED.Cidade,'') Cidade,
						isnull(ED.UF,'') UF,
						isnull(ED.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					FROM 
						FATURA_CHB FAT with(nolock)
						Join Fatura FT with(nolock)on FT.fatcod=FAT.bdp_Invoice
						Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
						JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
						LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'	
						join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx	
						left join boleto B on B.fatcod = FT.fatcod
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta		
					WHERE 
						FAT.FATURA_PC=@fatcod and FT.fatstatus = 1
					Group by
						FAT.FATURA_PC,PP.nome_raz_soc,PP.num_cpf_cnpj,FT.FatDtVenc,		
						B.dt_emissao_txt,B.cd_boleto ,B01.cd_instrucao,B01.nome_instrucao,B02.cd_instrucao,B02.nome_instrucao,
						ED.Rua,ED.numero,ED.Bairro,ED.CEP,ED.Cidade,ED.UF,ED.Compl_End, b.cd_banco --Alessandra 22/03/2022
						,B.Agencia_Cedente,	B.Conta_Cedente
				UNION ALL
					SELECT 
						FAT.FATURA_PC Fatura,
						PP.nome_raz_soc Sacado,
						PP.num_cpf_cnpj CNPJ,
						FT.FatDtVenc Vencimento,
						--'2000' agencia, 
						--'32499-2' conta,
						B.Agencia_Cedente agencia, 
						B.Conta_Cedente conta,
						--abs(convert(decimal(10,2),sum(dbo.valor(ITM.VLR_PC,ITM.DC)))) Valor,
						abs(convert(decimal(10,2),sum(ITM.VLR_PC))) Valor,
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(ED.Rua,'') Rua,
						isnull(ED.numero,'') Numero,
						isnull(ED.Bairro,'') Bairro,
						isnull(replace(ED.CEP,'-',''),'') CEP,
						isnull(ED.Cidade,'') Cidade,
						isnull(ED.UF,'') UF,
						isnull(ED.Compl_End,'') Complemento,
						isnull(b.cd_banco,'') cd_banco --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
					FROM 
						FATURA_CHB FAT with(nolock)
						JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC and imprime='S' and tp_pgto = 'B'	
						JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
						LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'			
						join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx	
						left join boleto B on B.fatcod = FAT.FATURA_PC
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01 and B01.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 and B02.cd_banco = B.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
						Join Fatura FT with(nolock)on FT.fatcod=FAT.FATURA_PC			
					WHERE 
						FAT.FATURA_PC=@fatcod and FT.fatstatus = 1
					Group By
						FAT.FATURA_PC,PP.nome_raz_soc,PP.num_cpf_cnpj,FT.FatDtVenc,		
						B.dt_emissao_txt,B.cd_boleto ,B01.cd_instrucao,B01.nome_instrucao,B02.cd_instrucao,B02.nome_instrucao,
						ED.Rua,ED.numero,ED.Bairro,ED.CEP,ED.Cidade,ED.UF,ED.Compl_End, b.cd_banco --Alessandra 22/03/2022
						,B.Agencia_Cedente,	B.Conta_Cedente
						
			END

Select
	Fatura,Sacado,CNPJ,MAx(Vencimento) Vencimento,
	Agencia +'-'+ A.Nome_Agencia Agencia,
	Conta,
	sum(Valor) Valor,DtTxt,NossoNumero,instrucao01,instrucao02,Rua,
	Numero,Bairro,CEP,Cidade,UF,Complemento,
	T.cd_banco+'-'+ B.Nome_Banco  cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta
from 
	@Temp T
	left join Banco B on B.cd_banco = T. cd_banco
	Left Join Agencia A on A.cd_agencia = T.Agencia
group by
	Fatura,Sacado,CNPJ,Agencia,Conta,DtTxt,NossoNumero,instrucao01,instrucao02,Rua,
	Numero,Bairro,CEP,Cidade,UF,Complemento,T.cd_banco  --Alessandra 22/03/2022 - tenho que saber o codigo do banco para puxar a instrução correta	
	,A.Nome_Agencia,B.Nome_Banco




--[spBoleto_Sel] 'EOCPE202111001BRA'
ALTER Procedure [dbo].[spBoleto_Sel]--'90000002'--'IMMCO201306001BRB'
	
	@fatcod		varchar(17)

as

SET NOCOUNT ON

Declare @Temp Table
(
	Fatura			Varchar(17),
	Sacado			Varchar(500),
	CNPJ			Varchar(50),
	Vencimento		Datetime,
	Agencia			Varchar(50),
	Conta			Varchar(50),
	Valor			Decimal(10,2),
	DtTxt			Datetime,
	NossoNumero		Varchar(50),
	instrucao01		Varchar(500),
	instrucao02		Varchar(500),
	Rua				Varchar(40),
	Numero			Varchar(10),
	Bairro			Varchar(100),
	CEP				varchar(8),
	Cidade			varchar(25),
	UF				varchar(2),
	Complemento		varchar(25)
)

	
		if len(@fatcod)= 8
			BEGIN
				insert into @Temp
					select 
						Numero_Fat Fatura,
						Razao_Social Sacado,
						num_CPF_CNPJ CNPJ,
						Vencimento Vencimento,
						'2000' agencia, 
						'32499-2' conta,
						convert(decimal(10,2),Total_FAT) Valor,		
						dt_emissao_txt DtTxt,
						cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(NF.Endereco,'') Rua,
						isnull(NF.Numero,'') Numero,
						isnull(NF.Bairro,'') Bairro,
						isnull(replace(NF.CEP,'-',''),'') CEP,
						isnull(NF.Cidade,'') Cidade,
						isnull(NF.UF,'') UF,
						isnull(E.Compl_End,'') Complemento
					from NF_Fatura NF
						left join endereco E on E.cd_pes = NF.cd_pes and E.cd_tp_end = 'COM'
						left join boleto B on B.fatcod = NF.Numero_Fat
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 
					where 
						Numero_Fat = @fatcod and Cd_Status <> 2			
			End
		else
			BEGIN
				insert into @Temp
					select 
						F.FatCod Fatura,
						P.nome_raz_soc Sacado,
						P.num_cpf_cnpj CNPJ,
						F.FatDtVenc Vencimento,
						'2000' agencia, 
						'32499-2' conta,
				--		sum(vlr_org) Valor,
						convert(decimal(10,2),sum(I.Paridade * dbo.valor(vlr_org,DC))) Valor,
				--		sum(isnull([dbo].[fParidadeFaturaARG](I.num_proc,cd_tp_moeda),dbo.FConverterMoeda(cd_tp_moeda,'REL')) * dbo.valor(vlr_org,DC)) Valor,					
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(E.Rua,'') Rua,
						isnull(E.numero,'') Numero,
						isnull(E.Bairro,'') Bairro,
						isnull(replace(E.CEP,'-',''),'') CEP,
						isnull(E.Cidade,'') Cidade,
						isnull(E.UF,'') UF,
						isnull(E.Compl_End,'') Complemento
					from fatura F
						join item_fat I on I.fatcod = F.fatcod
						join pessoa P on P.cd_pes = F.cd_pes
						left join endereco E on E.cd_pes = F.cd_pes and E.cd_tp_end = 'COM'
						left join boleto B on B.fatcod = F.fatcod
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02
						left Join Fatura_CHB FAT with(nolock)on F.fatcod=FAT.FATURA_PC
					where  
						F.fatcod = @fatcod  and F.fatstatus = 1
						and FAT.FATURA_PC is null
					group by 
						F.FatCod ,nome_raz_soc,num_cpf_cnpj,FatDtVenc,dt_emissao_txt,
						cd_boleto,B01.cd_instrucao,B02.cd_instrucao,B01.nome_instrucao,B02.nome_instrucao,
						E.Rua,E.Numero,E.Cep,E.Bairro,E.Cidade,E.UF,Compl_End
					
				UNION ALL
					select	
						FAT.FATURA_PC Fatura,
						PP.nome_raz_soc Sacado,
						PP.num_cpf_cnpj CNPJ,
						FT.FatDtVenc Vencimento,
						'2000' agencia, 
						'32499-2' conta,
						convert(decimal(10,2),sum(dbo.valor(IFT.Vlr_RS,IFT.DC))) Valor,			
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(ED.Rua,'') Rua,
						isnull(ED.numero,'') Numero,
						isnull(ED.Bairro,'') Bairro,
						isnull(replace(ED.CEP,'-',''),'') CEP,
						isnull(ED.Cidade,'') Cidade,
						isnull(ED.UF,'') UF,
						isnull(ED.Compl_End,'') Complemento
					FROM 
						FATURA_CHB FAT with(nolock)
						Join Fatura FT with(nolock)on FT.fatcod=FAT.bdp_Invoice
						Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
						JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
						LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'	
						join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx	
						left join boleto B on B.fatcod = FT.fatcod
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 		
					WHERE 
						FAT.FATURA_PC=@fatcod and FT.fatstatus = 1
					Group by
						FAT.FATURA_PC,PP.nome_raz_soc,PP.num_cpf_cnpj,FT.FatDtVenc,		
						B.dt_emissao_txt,B.cd_boleto ,B01.cd_instrucao,B01.nome_instrucao,B02.cd_instrucao,B02.nome_instrucao,
						ED.Rua,ED.numero,ED.Bairro,ED.CEP,ED.Cidade,ED.UF,ED.Compl_End
				UNION ALL
					SELECT 
						FAT.FATURA_PC Fatura,
						PP.nome_raz_soc Sacado,
						PP.num_cpf_cnpj CNPJ,
						FT.FatDtVenc Vencimento,
						'2000' agencia, 
						'32499-2' conta,
						--abs(convert(decimal(10,2),sum(dbo.valor(ITM.VLR_PC,ITM.DC)))) Valor,
						abs(convert(decimal(10,2),sum(ITM.VLR_PC))) Valor,
						B.dt_emissao_txt DtTxt,
						B.cd_boleto NossoNumero,
						B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
						B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
						isnull(ED.Rua,'') Rua,
						isnull(ED.numero,'') Numero,
						isnull(ED.Bairro,'') Bairro,
						isnull(replace(ED.CEP,'-',''),'') CEP,
						isnull(ED.Cidade,'') Cidade,
						isnull(ED.UF,'') UF,
						isnull(ED.Compl_End,'') Complemento
					FROM 
						FATURA_CHB FAT with(nolock)
						JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC and imprime='S' and tp_pgto = 'B'	
						JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
						LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'			
						join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx	
						left join boleto B on B.fatcod = FAT.FATURA_PC
						left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01
						left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02
						Join Fatura FT with(nolock)on FT.fatcod=FAT.FATURA_PC			
					WHERE 
						FAT.FATURA_PC=@fatcod and FT.fatstatus = 1
					Group By
						FAT.FATURA_PC,PP.nome_raz_soc,PP.num_cpf_cnpj,FT.FatDtVenc,		
						B.dt_emissao_txt,B.cd_boleto ,B01.cd_instrucao,B01.nome_instrucao,B02.cd_instrucao,B02.nome_instrucao,
						ED.Rua,ED.numero,ED.Bairro,ED.CEP,ED.Cidade,ED.UF,ED.Compl_End
						
			END

Select
	Fatura,Sacado,CNPJ,MAx(Vencimento) Vencimento,Agencia,Conta,sum(Valor) Valor,DtTxt,NossoNumero,instrucao01,instrucao02,Rua,
	Numero,Bairro,CEP,Cidade,UF,Complemento 
from 
	@Temp
group by
	Fatura,Sacado,CNPJ,Agencia,Conta,DtTxt,NossoNumero,instrucao01,instrucao02,Rua,
	Numero,Bairro,CEP,Cidade,UF,Complemento		

	--if len(@fatcod)= 8
	--	BEGIN
	--		select 
	--			Numero_Fat Fatura,
	--			Razao_Social Sacado,
	--			num_CPF_CNPJ CNPJ,
	--			Vencimento Vencimento,
	--			'2000' agencia, 
	--			'32499-2' conta,
	--			convert(decimal(10,2),Total_FAT) Valor,		
	--			dt_emissao_txt DtTxt,
	--			cd_boleto NossoNumero,
	--			B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
	--			B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
	--			isnull(NF.Endereco,'') Rua,
	--			isnull(NF.Numero,'') Numero,
	--			isnull(NF.Bairro,'') Bairro,
	--			isnull(replace(NF.CEP,'-',''),'') CEP,
	--			isnull(NF.Cidade,'') Cidade,
	--			isnull(NF.UF,'') UF,
	--			isnull(E.Compl_End,'') Complemento
	--		from NF_Fatura NF
	--			left join endereco E on E.cd_pes = NF.cd_pes and E.cd_tp_end = 'COM'
	--			left join boleto B on B.fatcod = NF.Numero_Fat
	--			left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01
	--			left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 
	--		where 
	--			Numero_Fat = @fatcod and Cd_Status <> 2			
	--	End
	--else
	--	BEGIN
	--		select 
	--			F.FatCod Fatura,
	--			nome_raz_soc Sacado,
	--			num_cpf_cnpj CNPJ,
	--			FatDtVenc Vencimento,
	--			'2000' agencia, 
	--			'32499-2' conta,
	--	--		sum(vlr_org) Valor,
	--			convert(decimal(10,2),sum(I.Paridade * dbo.valor(vlr_org,DC))) Valor,
	--	--		sum(isnull([dbo].[fParidadeFaturaARG](I.num_proc,cd_tp_moeda),dbo.FConverterMoeda(cd_tp_moeda,'REL')) * dbo.valor(vlr_org,DC)) Valor,					
	--			dt_emissao_txt DtTxt,
	--			cd_boleto NossoNumero,
	--			B01.cd_instrucao + '-' + B01.nome_instrucao instrucao01,
	--			B02.cd_instrucao + '-' + B02.nome_instrucao instrucao02,
	--			isnull(Rua,'') Rua,
	--			isnull(numero,'') Numero,
	--			isnull(Bairro,'') Bairro,
	--			isnull(replace(CEP,'-',''),'') CEP,
	--			isnull(Cidade,'') Cidade,
	--			isnull(UF,'') UF,
	--			isnull(Compl_End,'') Complemento
	--		from fatura F
	--			join item_fat I on I.fatcod = F.fatcod
	--			join pessoa P on P.cd_pes = F.cd_pes
	--			left join endereco E on E.cd_pes = F.cd_pes and E.cd_tp_end = 'COM'
	--			left join boleto B on B.fatcod = F.fatcod
	--			left join boleto_instrucao_cobranca B01 on B01.cd_instrucao = B.cd_instrucao_01
	--			left join boleto_instrucao_cobranca B02 on B02.cd_instrucao = B.cd_instrucao_02 
	--		where  F.fatcod = @fatcod and fatstatus = 1
	--		group by 
	--			F.FatCod ,nome_raz_soc,num_cpf_cnpj,FatDtVenc,dt_emissao_txt,
	--			cd_boleto,B01.cd_instrucao,B02.cd_instrucao,B01.nome_instrucao,B02.nome_instrucao,
	--			E.Rua,E.Numero,E.Cep,E.Bairro,E.Cidade,E.UF,Compl_End			
	--	END

*/

GO
