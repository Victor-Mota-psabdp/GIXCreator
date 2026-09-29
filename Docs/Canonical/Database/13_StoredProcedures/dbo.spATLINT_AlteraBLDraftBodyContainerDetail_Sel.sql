SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help spATLINT_AlteraBLDraftBodyContainerDetail_Sel
CREATE   procedure [dbo].[spATLINT_AlteraBLDraftBodyContainerDetail_Sel]
(
	@ID_ADBB                    bigint,
	@ID_ADBBCD                  bigint,
	@Tipo                       varchar(1)
)
as
if @Tipo ='A'
    Begin
			Select 
				ID_ADBB                   ,
				ID_ADBBCD                 ,
				CtrnType                  ,
				ContainerNo               ,
				Seal                      , 
				CAST(GrossWeight AS DECIMAL(10, 2)) as GrossWeight  ,
				CAST(NetWeight AS DECIMAL(10, 2))   as NetWeight    ,
				CAST(Tare AS DECIMAL(10, 2))        as Tare         ,
				CAST(CMS3 AS DECIMAL(10, 2))        as CMS3         ,
				NoOfPackg                 ,
	            TypeOfPackge              ,
                Ncm                       ,
				MarksandNumbers           ,
				CAST(Measurement AS DECIMAL(10, 2)) as Measurement               ,
				QtdCtnr                   ,
	            DescriptionOfPackagesAndGoods  
 
			from 
				ATL_INT.dbo.AlteraBLDraftBodyContainerDetail with(nolock)	
			Where
				ID_ADBB = @ID_ADBB
		End
if @Tipo ='C'
    Begin
			Select 
				ID_ADBB                   ,
				ID_ADBBCD                 ,
				CtrnType                  ,
				ContainerNo               ,
				Seal                      , 
				CAST(GrossWeight AS DECIMAL(10, 2)) as GrossWeight  ,
				CAST(NetWeight AS DECIMAL(10, 2))   as NetWeight    ,
				CAST(Tare AS DECIMAL(10, 2))        as Tare         ,
				CAST(CMS3 AS DECIMAL(10, 2))        as CMS3         ,
				NoOfPackg                 ,
	            TypeOfPackge              ,
                Ncm                       ,
				MarksandNumbers           ,
				CAST(Measurement AS DECIMAL(10, 2)) as Measurement               ,
				QtdCtnr                   ,
	            DescriptionOfPackagesAndGoods  
 			from 
				ATL_INT.dbo.AlteraBLDraftBodyContainerDetail with(nolock)	
			Where
				ID_ADBB = @ID_ADBB
			And	ID_ADBBCD = @ID_ADBBCD
		End


	


GO
