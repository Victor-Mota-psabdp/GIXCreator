SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Verifica_Status_Bloqueado_Sel]

 @Num_Proc Varchar(16)

AS



	If Left(@Num_Proc,1) = 'E' 
		BEGIN
			SELECT HOU.Cd_Dst, HOU.Cd_DstFinal, HOU.Cd_Consig, HOU.Cd_Notify FROM vwHouse_Exp HOU WITH(NOLOCK)
			JOIN Localidade Dst		WITH(NOLOCK) ON DST.Cd_Local = HOU.Cd_Dst    
			JOIN Localidade FDst	WITH(NOLOCK) ON FDst.Cd_Local = HOU.Cd_DstFinal  
			JOIN Pais P				WITH(NOLOCK) ON DST.Cd_Pais = P.Cd_Pais and FDst.Cd_Pais = P.Cd_Pais
			JOIN Pessoa Consig		WITH(NOLOCK) ON Consig.Cd_Pes = HOU.Cd_Consig
			JOIN Pessoa Notify		WITH(NOLOCK) ON Notify.Cd_Pes = HOU.Cd_Export

			WHERE	HOU.Num_Proc = @Num_Proc
					AND P.Bloqueado = 1
					AND P.Ativo = 1
		END


	Else
			SELECT HOU.Cd_Org, HOU.Cd_Planta, HOU.Cd_Export FROM vwHouse_Imp HOU WITH(NOLOCK)
			JOIN Localidade Org		WITH(NOLOCK) ON Org.Cd_Local = HOU.Cd_Org    
			JOIN Localidade Loading	WITH(NOLOCK) ON Loading.Cd_Local = HOU.Cd_Planta  
			JOIN Pais P				WITH(NOLOCK) ON Org.Cd_Pais = P.Cd_Pais and Loading.Cd_Pais = P.Cd_Pais
			JOIN Pessoa Export		WITH(NOLOCK) ON Export.Cd_Pes = HOU.Cd_Export

			WHERE	HOU.Num_Proc = @Num_Proc
					AND P.Bloqueado = 1
					AND P.Ativo = 1

			

GO
