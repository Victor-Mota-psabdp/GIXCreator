SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM Container_Avaria
--[spATL_TermoContainer_Avaria_Sel]'11'
--select * from pessoa where apelido like '%637C%'

--Givaudan 637C  - P000016137
--select * from pessoa where Cd_Pes ='P000016137'
--select * from Endereco where Cd_Pes ='P000016137' and Cd_Tp_End ='COM'
--update Endereco set numero = '2185' where Cd_Pes ='P000016137' and Cd_Tp_End ='COM'
--select * from Comunicacao where Cd_Pes ='P000016137' and Cd_Tp_Com ='EC1'

CREATE PROCEDURE [dbo].[spATL_TermoContainer_Avaria_Sel]--17
(
	@Codigo	int
)
AS

	select 
		Codigo,
		t.Num_Proc Num_Proc,
		BL,
		Container,
		(Case when Qty_Avaria is null then '' 
			Else
				(Case when Qty_Avaria IS NOT NULL then (Qty_Avaria + 'X') end)end) Qty_Avaria,
		Desc_Avaria,
		(Case when Qty_Avaria_2 is null then '' 
			Else
				(Case when Qty_Avaria_2 IS NOT NULL then (Qty_Avaria_2 + 'X') end)end) Qty_Avaria_2,
		Desc_Avaria_2,
		(Case when Qty_Avaria_3 is null then '' 
			Else
				(Case when Qty_Avaria_3 IS NOT NULL then (Qty_Avaria_3 + 'X') end)end) Qty_Avaria_3,
		Desc_Avaria_3,
		--A.Nome_Armador,
		ISNULL(T.nome_armador,A.Nome_Armador) Nome_Armador,
		I.Cd_Consig,
		P.Apelido,
		P.Num_RG_IE,

		--P.Nome_Raz_Soc  Nome_Raz_Soc,
		--P.Num_CPF_CNPJ  Num_CPF_CNPJ,
		--P.Num_Insc_Munic,
		--E.Rua  Rua, 
		--E.Numero  Numero,
		--E.Compl_End,
		--E.CEP  CEP,
		--E.Bairro Bairro,
		--E.Cidade  Cidade,
		--E.UF UF,
		--E.Pais,
		--C.Contato  Contato,
		--C.Depto_Ctt,
		--C.Cd_Int,
		--C.Cd_Area_Fone  Cd_Area_Fone,
		--C.Prefixo Prefixo,
		--Num_Fone,	
		--C.Compl_Fone Compl_Fone,
		--C.Ramal,
		--PG.Apelido [Grupo],
		--'Aprovado por: ' + U.Nome_Usuario + '|' +
		--'Telefone: ' + U.Fone + '|' +
		--'E-mail: ' + U.Email + '|' [AprovadoPor]
		

		--GIVAUDAN DO BRASIL LTDA
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then PGivaudan.Nome_Raz_Soc else P.Nome_Raz_Soc end) Nome_Raz_Soc,
		--Cnpj: 61.188.488/0001-17
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then PGivaudan.Num_CPF_CNPJ else P.Num_CPF_CNPJ end) Num_CPF_CNPJ,
		P.Num_Insc_Munic,
		--Endereço: Avenida Engenheiro Billing, 2.185 - . Cep: 05321-010
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then EGivaudan.Rua else E.Rua end) Rua, 
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then EGivaudan.Numero else E.Numero end) Numero,
		E.Compl_End,
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then EGivaudan.CEP else E.CEP end) CEP,
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then EGivaudan.Bairro else E.Bairro end) Bairro,
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then EGivaudan.Cidade else E.Cidade end) Cidade,
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then EGivaudan.UF else E.UF end) UF,
		E.Pais,
		--Pessoa de Contato: Claudia Barreto
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then CGivaudan.Contato else C.Contato end) Contato,
		C.Depto_Ctt,
		C.Cd_Int,
		--Telefone:(11)3760-7987
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then CGivaudan.Cd_Area_Fone else C.Cd_Area_Fone end) Cd_Area_Fone,
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then CGivaudan.Prefixo  else C.Prefixo end) Prefixo,
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then CGivaudan.Num_Fone else C.Num_Fone end) Num_Fone,	
		--E-mail: claudia.barreto@givaudan.com	
		(CASE WHEN P.Apelido LIKE 'Givaudan%' then CGivaudan.Compl_Fone else C.Compl_Fone end) Compl_Fone,
		C.Ramal,

		PG.Apelido [Grupo],
		(CASE WHEN P.Apelido LIKE 'Givaudan%' OR P.Apelido LIKE '%CORTEVA%'  then 
		'Aprovado por: Nome: Rosangela Santos' + '|' +
		'Telefone: (11) 5504:3408' + '|' +
		'E-mail: rosangela.santos@bdpint.com' + '|'
		else
		'Aprovado por: Nome: Roberta Beltran' + '|' +
		'Telefone: (11) 5504:3504' + '|'/* +
		'E-mail: roberta.beltran@bdpint.com' + '|' */
		end)	[AprovadoPor],
		ISNULL(T.Taxa_Indisponibilidade_Container,'USD 150,00 para unidades DRY e USD 350,00 para unidades Reefer') Taxa_Indisponibilidade_Container
		
	from 
		Container_Avaria T with(nolock)
		left join vwHouse_Imp	I	with(nolock) on I.Num_Proc = T.Num_Proc
		left join Armador		A	with(nolock) on a.Cd_Armador = I.Cd_Armador
		left join Pessoa		P	with(nolock) on p.Cd_Pes = I.Cd_Consig
		Left join Pessoa_LLP	PL	with(nolock) on I.Cd_Consig = PL.Cd_Pes
		Left Join  Grupo		G	with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo
		Left Join  pessoa		PG	with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo
		left join Endereco		E	with(nolock) on E.Cd_Pes = I.Cd_Consig and E.Cd_Tp_End = 'COM'
		left join Comunicacao	C with(nolock) on C.Cd_Pes = I.Cd_Consig and C.Cd_Tp_Com = 'EC1'
		Left Join Usuario		U with(nolock)  on G.Responsavel = U.Cd_Usuario
		left join Pessoa		PGivaudan	with(nolock) on PGivaudan.Cd_Pes = 'P000016137'
		left join Endereco		EGivaudan	with(nolock) on EGivaudan.Cd_Pes = 'P000016137' and EGivaudan.Cd_Tp_End = 'COM'
		left join Comunicacao	CGivaudan	with(nolock) on CGivaudan.Cd_Pes = 'P000016137' and CGivaudan.Cd_Tp_Com = 'EC1'
	where 
		T.Codigo = @Codigo
		

--Faturar para:
--GIVAUDAN DO BRASIL LTDA
--Endereço: Avenida Engenheiro Billing, 2.185 - . Cep: 05321-010
--Cnpj: 61.188.488/0001-17
--Insc. Estadual:102705856113
--Pessoa de Contato: Claudia Barreto
--E-mail: claudia.barreto@givaudan.com
--Telefone:(11)3760-7987

--Aprovado por: Nome: Rosangela Santos
--Telefone: (11) 5504:3408
--E-mail: rosangela.santos@bdpint.com
		
  
 
 
 
 
 
 


GO
