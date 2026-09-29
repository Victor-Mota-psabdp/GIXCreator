SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_Pessoa_Aeroporto](
	@cd_local	char(3)	
)
RETURNS varchar(1000)

BEGIN

	Declare @Resultado varchar(1000)

	IF @cd_local = 'GRU'
		Begin
			SET @Resultado=(select 
								isnull(Nome_raz_soc,'') + '(' + isnull(Rua,'') + ')' + '|' +
								isnull(CO.Contato,'') + '|' + 
								'Nextel ID: ' + CO.depto_ctt + '-' + '(' + isnull(CO.cd_area_fone,'') + ')' + isnull(CO.prefixo + CO.num_fone,'') + '|' +
								isnull(CO1.Contato,'') + '|' + 
								'Nextel ID: ' + CO1.depto_ctt + '-' + '(' + isnull(CO1.cd_area_fone,'') + ')' + isnull(CO1.prefixo + CO1.num_fone,'') + '|'								
						From Pessoa P
							left join endereco EN on EN.cd_pes = P.cd_pes
							left join comunicacao CO on CO.cd_pes = P.cd_pes and CO.cd_tp_com = 'EM1'
							left join comunicacao CO1 on CO1.cd_pes = P.cd_pes and CO1.cd_tp_com = 'EM2'
						where 
							P.cd_pes = 'P000009941')
		End

	ELSE IF @cd_local = 'VCP'
		Begin
			SET @Resultado=(select 
							isnull(Nome_raz_soc,'') + '|' 
							+ isnull(Rua,'') + '|' +							
							isnull(CO.Contato,'') + '|' + 
								'Nextel ID: ' + CO.depto_ctt + '|'
					From Pessoa P
						left join endereco EN on EN.cd_pes = P.cd_pes
						left join comunicacao CO on CO.cd_pes = P.cd_pes and cd_tp_com = 'EM1'
					where 
						P.cd_pes = 'P000009942')
		End

	ELSE IF @cd_local = 'SSA'
		Begin
			SET @Resultado=(select 
							isnull(Nome_raz_soc,'') + '|'
							+ isnull(Rua,'') + ',' + isnull(Numero,'') + ' ' + isnull(Compl_End,'')  + '|' +
							isnull(Bairro,'') + ' ' + Cidade + '/' + UF + '|' + 
							+ 'Tel: ' + '(' + isnull(cd_area_fone,'') + ')' + isnull(prefixo + num_fone,'') + '|' +
							isnull(Contato,'') + '|'
					From Pessoa P
						left join endereco EN on EN.cd_pes = P.cd_pes
						left join comunicacao CO on CO.cd_pes = P.cd_pes and cd_tp_com = 'EM1'
					where 
						P.cd_pes = 'P11793')
		End

	ELSE IF @cd_local = 'GIG'
		Begin
			SET @Resultado=(select 
							isnull(Nome_raz_soc,'') + '|'
							+ isnull(Rua,'') + ',' + isnull(Numero,'') + ' ' + isnull(Compl_End,'')  + '|' +
							isnull(Bairro,'') + ' ' + Cidade + '/' + UF + '|' + 
							+ 'Tel: ' + '(' + isnull(cd_area_fone,'') + ')' + isnull(prefixo + num_fone,'') + '|' +
							isnull(Contato,'') + '|'
					From Pessoa P
						left join endereco EN on EN.cd_pes = P.cd_pes
						left join comunicacao CO on CO.cd_pes = P.cd_pes and cd_tp_com = 'EM1'
					where 
						P.cd_pes = 'P11675')
		End

	ELSE IF @cd_local = 'FOR' or @cd_local = 'REC'
		Begin
			SET @Resultado=(select 
							isnull(Nome_raz_soc,'') + '|'
							+ isnull(Rua,'') + ',' + isnull(Numero,'') + ' ' + isnull(Compl_End,'')  + '|' +
							isnull(Bairro,'') + ' ' + Cidade + '/' + UF + '|' + 
							+ 'Tel: ' + '(' + isnull(cd_area_fone,'') + ')' + isnull(prefixo + num_fone,'') + '|' +
							isnull(Contato,'') + '|'
					From Pessoa P
						left join endereco EN on EN.cd_pes = P.cd_pes
						left join comunicacao CO on CO.cd_pes = P.cd_pes and cd_tp_com = 'EM1'
					where 
						P.cd_pes = 'P11701')
		End

	RETURN @Resultado

END


GO
