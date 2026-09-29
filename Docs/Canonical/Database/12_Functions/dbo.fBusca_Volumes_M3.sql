SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_Volumes_M3] 
(
	@Processo	Varchar(16)
)

RETURNS decimal(18,2)

AS  
BEGIN
	Declare @Saida decimal(18,2)
	--Set @Saida = (Select sum(
	--					convert(int,Compr_EA * 100)		* 
	--					convert(int,Largura_EA * 100)	* 
	--					convert(int,Altura_EA * 100)	* 
	--					convert(int,Qtd_Vol_EA)/6000)
	--from Volume_Exp_Aer HOU with(nolock)	Where	num_proc_hea =@Processo)

	Set @Saida = (Select sum(
							convert(decimal(18,2),
								(convert(decimal(18,2),
									(
										convert(int,Compr_EA * 100) * convert(int,Largura_EA * 100) * convert(int,Altura_EA * 100) * convert(int,Qtd_Vol_EA))
									)
								/6000)
							)
						)
			from Volume_Exp_Aer HOU with(nolock) Where num_proc_hea =@Processo)

	--Select	
	--		--convert(int,Compr_EA * 100),
	--		--convert(int,Largura_EA * 100),	
	--		--convert(int,Altura_EA * 100),
	--		--Qtd_Vol_EA,
	--		--convert(int,Compr_EA * 100) * convert(int,Largura_EA * 100) * convert(int,Altura_EA * 100),
	--		--convert(int,Compr_EA * 100) * convert(int,Largura_EA * 100) * convert(int,Altura_EA * 100) * convert(int,Qtd_Vol_EA),
	--		isnull(sum(convert(int,Compr_EA * 100) * convert(int,Largura_EA * 100) * convert(int,Altura_EA * 100) * convert(int,Qtd_Vol_EA)/6000),0)

	--	--convert(Varchar(10),
	--	--	convert(int,Compr_EA * 100) * convert(int,Largura_EA * 100) * convert(int,Altura_EA * 100) * Qtd_Vol_EA )
	--	from 
	--		Volume_Exp_Aer HOU with(nolock)
	--	Where
	--		num_proc_hea ='EAATL201908036BR'


	Return @SAida
	
END












GO
