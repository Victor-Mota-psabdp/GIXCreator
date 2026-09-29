SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[spATLINT_AlteraBLDraftBodyContainerDetail_InsUpd]

  	@ID_ADBB                        [bigint],
	@ID_ADBBCD                      [bigint],
	@CtrnType                       [varchar](200) NULL,
	@ContainerNo                    [varchar](200) NULL,
	@Seal                           [varchar](200) NULL,
	@GrossWeight                    [varchar](200) NULL,
	@NetWeight                      [varchar](200) NULL,
	@Tare                           [varchar](200) NULL,
	@CMS3                           [varchar](200) NULL,
	@NoOfPackg                      [varchar](200) NULL,
	@TypeOfPackge                   [varchar](200) NULL,
    @Ncm                            [varchar](200) NULL,
	@MarksandNumbers                [varchar](200) NULL,
	@Measurement                    [varchar](200) NULL,
	@QtdCtnr                        [varchar](200) NULL,
	@DescriptionOfPackagesAndGoods  [varchar](4000) NULL

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help spATLINT_AlteraBLDraftBodyContainerDetail_InsUpd   
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_ADBB, ID_ADBBCD from ATL_INT.dbo.AlteraBLDraftBodyContainerDetail where ID_ADBB = @ID_ADBB and ID_ADBBCD = @ID_ADBBCD)
			Begin
				Update
					ATL_INT.dbo.AlteraBLDraftBodyContainerDetail 
				set   
					CtrnType = @CtrnType               ,
					ContainerNo = @ContainerNo         ,
					Seal = @Seal                       ,
					GrossWeight = @GrossWeight         ,
					NetWeight = @NetWeight             ,
					Tare = @Tare                       ,
					CMS3 = @CMS3                       ,       
					NoOfPackg = @NoOfPackg             ,
	                TypeOfPackge = @TypeOfPackge       ,
                    Ncm=  @Ncm                         ,
					MarksandNumbers = @MarksandNumbers ,
					Measurement = @Measurement         ,
					QtdCtnr = @QtdCtnr                 ,
	                DescriptionOfPackagesAndGoods = @DescriptionOfPackagesAndGoods  
					Where  	ID_ADBB = @ID_ADBB 
			    	And     ID_ADBBCD = @ID_ADBBCD  
   			        set @ID_New = @ID_ADBBCD 
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_ADBBCD),0)+1 FROM ATL_INT.dbo.AlteraBLDraftBodyContainerDetail where  ID_ADBB = @ID_ADBB) 
				
				Insert ATL_INT.dbo.AlteraBLDraftBodyContainerDetail
				(	
					ID_ADBB                   ,
					ID_ADBBCD                 ,
					CtrnType                  ,
					ContainerNo               ,
					Seal                      ,
					GrossWeight               ,
					NetWeight                 ,
					Tare                      ,
					CMS3                      ,
					NoOfPackg                 ,
	                TypeOfPackge              ,
                    Ncm                       ,
					MarksandNumbers           ,
					Measurement               ,
					QtdCtnr                   ,
	                DescriptionOfPackagesAndGoods  
                )					
				Values
				(
					@ID_ADBB                   ,
					@ID_NEW                    ,	
					@CtrnType                  ,
					@ContainerNo               ,
					@Seal                      ,
					@GrossWeight               ,
					@NetWeight                 ,
					@Tare                      ,
					@CMS3                      ,
					@NoOfPackg                 ,
	                @TypeOfPackge              ,
                    @Ncm                       ,
					@MarksandNumbers           ,
					@Measurement               ,
					@QtdCtnr                   ,
	                @DescriptionOfPackagesAndGoods  
				)
			END	

		Select @ID_New as Retorno;
				
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END


GO
