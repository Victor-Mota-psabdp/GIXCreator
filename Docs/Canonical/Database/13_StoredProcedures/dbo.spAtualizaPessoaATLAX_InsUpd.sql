SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAtualizaPessoaATLAX_InsUpd]
as


Declare @YourAccountNum	Varchar(12)
Declare @AccountNum		int
Declare @CNPJ				Varchar(20)
Declare @TaxGroup		Varchar(15)
Declare @Tipo			Char(1)
Declare cTemp cursor for
--VEndGroup == NOT indica que é um cadastro de um fornecedor Administrativo.
		select YourAccountNum,AccountNum,CNPJCPFNum,TaxGroup,'F' Tipo From dbo.AX_XML_Vendor_Recebido Where VEndGroup <> 'NOT' and dt_envio_atl is null 

Open cTemp
	Fetch Next From cTemp into @YourAccountNum,@AccountNum,@CNPJ,@TaxGroup,@Tipo	
	While @@FETCH_STATUS = 0
		Begin
			--Apagar registro Atual
			if @CNPJ is not null 
				Begin
					delete Pessoa_atl_ax where cd_ax=@AccountNum	and tipo='F'		
				End
			Else
				Begin
					delete Pessoa_atl_ax where cd_ax=@AccountNum and cd_pes=@YourAccountNum and tipo='F'	
				
				End
			--Inserir pessoa_ATL_AX que tenha o cd_pes definido
			insert Pessoa_atl_ax
			select YourAccountNum,AccountNum,CNPJCPFNum,TaxGroup,'F' Tipo From dbo.AX_XML_Vendor_Recebido Where VEndGroup <> 'NOT' and YourAccountNum is not null and accountnum=@AccountNum
			print 'Inserindo por CNPJ'
			print @CNPJ
			print @AccountNum
			print @YourAccountNum
			
			Insert Pessoa_ATL_AX
			select P.cd_pes,@AccountNum,@CNPJ,@TaxGroup,@Tipo	from pessoa P
			left join Pessoa_ATL_AX PA on P.Cd_Pes = PA.Cd_Pes
			where 
				(P.cd_pes <> @YourAccountNum or @YourAccountNum is null) and right(num_cpf_cnpj,14)=replace(replace(replace(@CNPJ,'-',''),'.',''),'/','') and len(num_cpf_cnpj)>1
				--Cadu04/04/2021 - 14:29h incluido oP.Desat_Pes = 'N' - pq o AccountNum 2447  ja existia o CNPJ p outro cadastro 
				and P.Desat_Pes = 'N'
			-- Alessandra 03/12/2019 - Para cadastrar o vendor a chave tem quer ser cnpj + accountnum
			--and REPLACE(obs_pes,'Integração Dynamics AX - Vend - AccountNUM = ','') = convert(varchar(10),@AccountNum)
			
			update 	AX_XML_Vendor_Recebido set dt_envio_ATL=getdate() where AccountNum=@AccountNum

			Fetch Next From cTemp into @YourAccountNum,@AccountNum,@CNPJ,@TaxGroup,@Tipo			
		End
		
GO
